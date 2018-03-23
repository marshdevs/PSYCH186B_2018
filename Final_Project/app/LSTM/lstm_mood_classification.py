import os
from keras.models import Sequential
from keras.layers.recurrent import LSTM
from keras.layers import Dense, Activation
from keras.optimizers import Adam, SGD, Adamax 
from MoodFeatureData import MoodFeatureData  # local python class with Audio feature extraction (librosa)

# Turn off TF verbose logging
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # or any {'0', '1', '2'}

mood_features = MoodFeatureData()
mood_features.load_preprocess_data()

# Keras optimizer defaults:
# Adam   : lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-8, decay=0.
# Adamax : lr=0.002, beta_1=0.9, beta_2=0.999, epsilon=None, decay=0.0
# SGD    : lr=0.01, momentum=0., decay=0.
opt = Adam()

batch_size = 100
nb_epochs = 1000

print("Training X shape: " + str(mood_features.train_X.shape))
print("Training Y shape: " + str(mood_features.train_Y.shape))
print("Validation X shape: " + str(mood_features.dev_X.shape))
print("Validation Y shape: " + str(mood_features.dev_Y.shape))
print("Test X shape: " + str(mood_features.test_X.shape))
print("Test Y shape: " + str(mood_features.test_X.shape))

input_shape = (mood_features.train_X.shape[1], mood_features.train_X.shape[2])
print('Building LSTM model ...')
model = Sequential()
model.add(LSTM(units=128, dropout=0.05, recurrent_dropout=0.35, return_sequences=True, input_shape=input_shape))
model.add(LSTM(units=32, dropout=0.05, recurrent_dropout=0.35, return_sequences=False))
model.add(Dense(units=mood_features.train_Y.shape[1], activation='softmax'))

print("Compiling Model...")
model.compile(loss='categorical_crossentropy', optimizer=opt, metrics=['accuracy'])
model.summary()

print("Training...")
model.fit(mood_features.train_X, mood_features.train_Y, batch_size=batch_size, epochs=nb_epochs, shuffle=True)

print("\nValidating ...")
score, accuracy = model.evaluate(mood_features.dev_X, mood_features.dev_Y, batch_size=batch_size, verbose=1)
print("Validation loss:  ", score)
print("Validation accuracy:  ", accuracy)

print("\nTesting ...")
score, accuracy = model.evaluate(mood_features.test_X, mood_features.test_Y, batch_size=batch_size, verbose=1)
print("Test loss:  ", score)
print("Test accuracy:  ", accuracy)

print("\nPredicting Probability...")
prediction = model.predict_proba(mood_features.test_X, batch_size=batch_size, verbose=1)
print("prediction: ", prediction) 

print("\nPredicting Classes...")
prediction = model.predict_classes(mood_features.test_X, batch_size=batch_size, verbose=1)
print("prediction: ", prediction) 

expected = "[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 3,3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]"
print("expected: ", expected)