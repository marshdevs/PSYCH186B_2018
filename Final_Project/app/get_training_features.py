import numpy as np
import matplotlib.pyplot as plt
import matplotlib.style as ms
ms.use('seaborn-muted')
import IPython.display

import librosa
import librosa.display

import re
import csv

import optparse
import glob

parser = optparse.OptionParser()

# # # # # # # # classdef

class Distribution:
	def __init__(self, mood):
		self.mood = mood
		self.intensities = np.array([])
		self.pitches = np.array([])
		self.timbres = np.array([])
		self.times = np.array([])
		self.empty = 1

	def new_song(self, intensities, pitches, timbres, time):
		self.empty = 0
		self.add_intensities(intensities)
		self.add_pitches(pitches)
		self.add_timbres(timbres)
		self.add_time(time)

	def add_intensities(self, intensities):
		self.intensities = np.append(self.intensities, intensities)

	def add_pitches(self, pitches):
		self.pitches = np.append(self.pitches, pitches)	

	def add_timbres(self, timbres):
		self.timbres = np.append(self.timbres, timbres)

	def add_time(self, time):
		self.times = np.append(self.times, time)

	def song_report(self, song_name, writer):
		song_stats = {
			'song': song_name,
			'mood': self.mood,
			'max_intensity': np.max(self.intensities), 
			'min_intensity': np.min(self.intensities), 
			'mean_intensity': np.mean(self.intensities), 
			'median_intensity': np.median(self.intensities), 
			'max_pitch': np.max(self.pitches), 
			'min_pitch': np.min(self.pitches), 
			'mean_pitch': np.mean(self.pitches), 
			'median_pitch': np.median(self.pitches), 
			'max_timbre': np.max(self.timbres), 
			'min_timbre': np.min(self.timbres), 
			'mean_timbre': np.mean(self.timbres), 
			'median_timbre': np.median(self.timbres), 
			'max_time': np.max(self.times), 
			'min_time': np.min(self.times), 
			'mean_time': np.mean(self.times), 
			'median_time': np.median(self.times)
		}
		writer.writerow(song_stats)

# # # # # # # # util

def init(root):
	return glob.glob(root + r"*[.wav|.au]")

def csv_song_init(root):
	options, args = parser.parse_args()
	if root == 'res/_train/':
		file_path = 'data/train/song_statistics.csv'
	else:
		file_path = 'data/test/test_song_statistics.csv'
	song_file = open(file_path, 'w')
	song_fieldnames = ['song', 'mood', 'max_intensity', 'min_intensity', 'mean_intensity', 'median_intensity', 'max_pitch', 'min_pitch', 'mean_pitch', 'median_pitch', 'max_timbre', 'min_timbre', 'mean_timbre', 'median_timbre', 'max_time', 'min_time', 'mean_time', 'median_time']
	song_writer = csv.DictWriter(song_file, fieldnames=song_fieldnames)
	song_writer.writeheader()
	return song_writer

def get_intensity(y, sr, beats):
	# Beat-synchronous Loudness - Intensity
	CQT = librosa.cqt(y, sr=sr, fmin=librosa.note_to_hz('A1'))
	freqs = librosa.cqt_frequencies(CQT.shape[0], fmin=librosa.note_to_hz('A1'))
	perceptual_CQT = librosa.perceptual_weighting(CQT**2, freqs, ref=np.max)
	CQT_sync = librosa.util.sync(perceptual_CQT, beats, aggregate=np.median)
	return CQT_sync

def get_pitch(y_harmonic, sr, beats):
	# Chromagram
	C = librosa.feature.chroma_cqt(y=y_harmonic, sr=sr)

	# Beat-synchronous Chroma - Pitch
	C_sync = librosa.util.sync(C, beats, aggregate=np.median)
	return C_sync

def get_timbre(y, sr, beats):
	# Mel spectogram
	S = librosa.feature.melspectrogram(y, sr=sr, n_mels=128)
	log_S = librosa.power_to_db(S, ref=np.max)

	# MFCC - Timbre
	mfcc = librosa.feature.mfcc(S=log_S, n_mfcc=13)
	delta_mfcc  = librosa.feature.delta(mfcc)
	delta2_mfcc = librosa.feature.delta(mfcc, order=2)
	M = np.vstack([mfcc, delta_mfcc, delta2_mfcc])
	# Beat-synchronous MFCC - Timbre
	M_sync = librosa.util.sync(M, beats)
	return M_sync

# # # # # # # # main

def analyze(root):
	sounds = init(root)
	song_writer = csv_song_init(root)

	sounds.sort()
	for sound in sounds:
		audio_path = sound
		audio_name = re.findall(r'.*/(.*)\.[wavau]*$', audio_path)[0]
		audio_mood = re.findall(r'([^0-9]*)\.[0-9]*$', audio_name)[0]

		song_statistics = Distribution(audio_mood)

		# Time series
		y, sr = librosa.load(audio_path, sr=44100)
		song_duration = librosa.get_duration(y=y, sr=sr)

		# Harmonic-Percussive Source separation
		y_harmonic, y_percussive = librosa.effects.hpss(y)

		# Beat Tracking
		tempo, beats = librosa.beat.beat_track(sr=sr, onset_envelope=librosa.onset.onset_strength(y=y_percussive, sr=sr), trim=False)

		CQT_sync = get_intensity(y, sr, beats)
		C_sync = get_pitch(y_harmonic, sr, beats)
		M_sync = get_timbre(y, sr, beats)

		print("# Feature aggregation: " + audio_name)
		intensity_frames = np.matrix(CQT_sync).getT()
		# print("Shape of Intensity spectogram: ")
		# print(intensity_frames.shape)
		pitch_frames = np.matrix(C_sync).getT()
		# print("Shape of Pitch spectogram: ")
		# print(pitch_frames.shape)
		timbre_frames = np.matrix(M_sync).getT()
		# print("Shape of Timbre spectogram: ")
		# print(timbre_frames.shape)

		for beat in range(len(beats)):
			# print("Frame: " + str(beat))
			intensity_frame = np.array(intensity_frames[beat,:])[0]
			# print(" - Mean intensity: " + str(np.mean(intensity_frame)))
			pitch_frame = np.array(pitch_frames[beat,:])[0]
			# print(" - Mean pitch: " + str(np.mean(pitch_frame)))
			timbre_frame = np.array(timbre_frames[beat,:])[0]
			# print(" - Mean timbre: " + str(np.mean(timbre_frame)))

			frame_time = 0
			if (beat == 0):
				frame_time = str(librosa.frames_to_time(beats, sr=sr)[0])
			else:
				frame_time = librosa.frames_to_time(beats, sr=sr)[beat] - librosa.frames_to_time(beats, sr=sr)[beat - 1]
			# print(" - Frame time (tempo): " + str(frame_time))

			# frames_writer.writerow({'name': audio_name, 'frame': beat, 'intensity_spectrum': intensity_frame, 'pitch_spectrum': pitch_frame, 'timbre_spectrum': timbre_frame, 'frame_time': frame_time, 'mean_intensity': np.mean(intensity_frame), 'median_intensity': np.median(intensity_frame), 'mean_pitch': np.mean(pitch_frame) , 'median_pitch': np.median(pitch_frame), 'mean_timbre': np.mean(timbre_frame), 'median_timbre': np.median(timbre_frame)})
			
			song_statistics.new_song(intensity_frame, pitch_frame, timbre_frame, float(frame_time))

		print("$ Done - Wrote " + str(len(beats)) + " frames.")
		song_statistics.song_report(audio_name, song_writer)


