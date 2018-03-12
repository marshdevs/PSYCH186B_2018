import csv
import tensorflow as tf
import numpy as np
import get_test_features as read_test_audio
import get_training_features as read_training_audio

# # # # # # # # globals

mood_dict = {'aggressive': 0,'calm': 1,'happy': 2,'sad': 3}
mood_dict_reverse = {0: 'aggressive', 1: 'calm', 2: 'happy', 3: 'sad'}

batch_size = 100
train_steps = 5000

# # # # # # # # init

def csv_init(csv_path):
	songs = []
	csv_file = open(csv_path, 'r')
	fieldnames = ['song', 'mood', 'max_intensity', 'min_intensity', 'mean_intensity', 'median_intensity', 'max_pitch', 'min_pitch', 'mean_pitch', 'median_pitch', 'max_timbre', 'min_timbre', 'mean_timbre', 'median_timbre', 'max_time', 'min_time', 'mean_time', 'median_time']
	reader = csv.DictReader(csv_file, fieldnames=fieldnames)
	reader.next()
	
	for row in reader:
		songs.append(row)
	return songs

# # # # # # # # tensorflow

def input_evaluation_set(song_specs):
	features = {
		'max_intensity': np.array([]),
		'min_intensity': np.array([]),
		'mean_intensity': np.array([]), 
		'median_intensity': np.array([]), 
		'max_pitch': np.array([]), 
		'min_pitch': np.array([]), 
		'mean_pitch': np.array([]), 
		'median_pitch': np.array([]), 
		'max_timbre': np.array([]), 
		'min_timbre': np.array([]), 
		'mean_timbre': np.array([]), 
		'median_timbre': np.array([]), 
		'max_time': np.array([]), 
		'min_time': np.array([]), 
		'mean_time': np.array([]), 
		'median_time': np.array([])
	}
	labels = []

	unused_features = [
	# 'max_intensity',
	# 'min_intensity',
	# 'mean_intensity',
	# 'median_intensity', 
	# 'max_pitch', 
	# 'min_pitch', 
	# 'mean_pitch', 
	# 'median_pitch', 
	# 'max_timbre', 
	# 'min_timbre', 
	# 'mean_timbre', 
	# 'median_timbre', 
	# 'max_time', 
	# 'min_time', 
	# 'mean_time', 
	# 'median_time',
	'song',
	]

	for each in song_specs:
		for key in song_specs[0]:
			if key not in unused_features:
				if key == 'mood':
					labels.append(int(mood_dict[each[key]]))
				else:
					features[key] = np.append(features[key], float(each[key]))

	return features, labels

def input_test_set(song_specs):
	features = {
		'max_intensity': np.array([]),
		'min_intensity': np.array([]),
		'mean_intensity': np.array([]), 
		'median_intensity': np.array([]), 
		'max_pitch': np.array([]), 
		'min_pitch': np.array([]), 
		'mean_pitch': np.array([]), 
		'median_pitch': np.array([]), 
		'max_timbre': np.array([]), 
		'min_timbre': np.array([]), 
		'mean_timbre': np.array([]), 
		'median_timbre': np.array([]), 
		'max_time': np.array([]), 
		'min_time': np.array([]), 
		'mean_time': np.array([]), 
		'median_time': np.array([])
	}
	labels = []

	unused_features = [
	'mood',
	'song',
	]

	for each in song_specs:
		for key in song_specs[0]:
			if key not in unused_features:
				features[key] = np.append(features[key], float(each[key]))

	return features, labels

def train_input_fn(features, labels, batch_size):
    """An input function for training"""
    # Convert the inputs to a Dataset.
    dataset = tf.data.Dataset.from_tensor_slices((dict(features), labels))

    # Shuffle, repeat, and batch the examples.
    return dataset.shuffle(1000).repeat().batch(batch_size)

def eval_input_fn(features, labels, batch_size):
	features = dict(features)
	if labels == None:
		inputs = features
	else:
		inputs = (features, labels)
	dataset = tf.data.Dataset.from_tensor_slices(inputs)
	dataset = dataset.batch(batch_size)
	return dataset

# # # # # # # # model

def train_model(classifier):
	# read_training_audio.analyze('res/_train/')
	training_songs = csv_init('data/train/song_statistics.csv')
	train_features, train_labels = input_evaluation_set(training_songs)

	classifier.train(
		input_fn=lambda:train_input_fn(train_features, train_labels, batch_size),
		steps=train_steps)

	eval_result = classifier.evaluate(
		input_fn=lambda:eval_input_fn(train_features, train_labels, batch_size))

	print('\nTraining set accuracy: {accuracy:0.3f}\n'.format(**eval_result))

def test_model(classifier):
	# read_training_audio.analyze('res/_test/')
	test_songs = csv_init('data/test/test_song_statistics.csv')
	test_features, test_labels = input_evaluation_set(test_songs)

	eval_result = classifier.evaluate(
		input_fn=lambda:eval_input_fn(test_features, test_labels, batch_size))

	print('\nTest set accuracy: {accuracy:0.3f}\n'.format(**eval_result))


def predict_model(classifier, file):
	results = []
	beats = read_test_audio.analyze(file)

	test_songs = csv_init('data/predict/predict_song_statistics.csv')
	test_features, test_labels = input_test_set(test_songs)

	predictions = classifier.predict(
		input_fn=lambda:eval_input_fn(test_features, labels=None, batch_size=batch_size))

	for pred in predictions:
		class_id = pred['class_ids'][0]
		probability = pred['probabilities'][class_id]
		results.append([mood_dict_reverse[class_id], 100 * probability])

	return results, beats

