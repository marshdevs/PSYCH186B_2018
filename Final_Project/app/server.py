import os
from flask import Flask, request, Response, render_template, send_from_directory
import tensorflow as tf
import classify_mood as model
import json

app = Flask(__name__, static_url_path='/Users/marsh/Desktop/Education/Classes/Winter18/PSYCH186B_2018/Final_Project/app/static')

feature_columns = ['max_intensity','min_intensity','mean_intensity','median_intensity', 'max_pitch', 'min_pitch', 'mean_pitch', 'median_pitch', 
	'max_timbre', 'min_timbre', 'mean_timbre', 'median_timbre', 'max_time', 'min_time', 'mean_time', 'median_time']

my_feature_columns = []
for key in feature_columns:
	my_feature_columns.append(tf.feature_column.numeric_column(key=key))

classifier = tf.estimator.DNNClassifier(
		feature_columns=my_feature_columns,
		hidden_units=[250,250],
		n_classes=4
	)

@app.before_first_request
def model_init():
	model.train_model(classifier)

@app.route('/favicon.ico')
def favicon():
	return send_from_directory(os.path.join(app.root_path, 'static'), 'img/mmm.ico')

@app.route('/<string:page_name>/', methods=['GET'])
def static_page(page_name):
	return render_template('%s.html' % page_name)

@app.route('/song/', methods=['POST'])
def get_mood():
	file_path = 'uploaded_audio'
	file = request.files['file']
	print(file)
	file.save(file_path)

	# model.test_model(classifier)

	results, beats = model.predict_model(classifier, file_path)
	print(results)

	return Response(json.dumps({
		'predictions': results,
		'beats': beats,
		'success': True
	}), mimetype=u'application/json')

# # # # # # # # main

if __name__ == "__main__": app.run(debug=True)