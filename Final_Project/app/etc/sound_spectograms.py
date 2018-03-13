import numpy as np
import matplotlib.pyplot as plt
import matplotlib.style as ms
ms.use('seaborn-muted')
import IPython.display

import librosa
import librosa.display

import re
import csv

csv_file = open('audio_frames.csv', 'w')
csv_fieldnames = ['name', 'frame', 'intensity_spectrum', 'pitch_spectrum', 'timbre_spectrum', 'frame_time']
csv_writer = csv.DictWriter(csv_file, fieldnames=csv_fieldnames)
csv_writer.writeheader()

audio_path = 'happy1(Sad Demo).wav'
audio_name = re.findall(r'.*\.wav$', audio_path)[0]

# Time series
y, sr = librosa.load(audio_path, sr=44100)
song_duration = librosa.get_duration(y=y, sr=sr)
print(y)

# Mel spectogram
S = librosa.feature.melspectrogram(y, sr=sr, n_mels=128)
log_S = librosa.power_to_db(S, ref=np.max)
plt.figure(figsize=(12,4))
librosa.display.specshow(log_S, sr=sr, x_axis='time', y_axis='mel')
plt.title('mel power spectrogram')
plt.colorbar(format='%+02.0f dB')

plt.tight_layout()

# Harmonic-percussive source separation
y_harmonic, y_percussive = librosa.effects.hpss(y)
S_harmonic   = librosa.feature.melspectrogram(y_harmonic, sr=sr)
S_percussive = librosa.feature.melspectrogram(y_percussive, sr=sr)
log_Sh = librosa.power_to_db(S_harmonic, ref=np.max)
log_Sp = librosa.power_to_db(S_percussive, ref=np.max)
plt.figure(figsize=(12,6))

plt.subplot(2,1,1)
librosa.display.specshow(log_Sh, sr=sr, y_axis='mel')
plt.title('mel power spectrogram (Harmonic)')
plt.colorbar(format='%+02.0f dB')

plt.subplot(2,1,2)
librosa.display.specshow(log_Sp, sr=sr, x_axis='time', y_axis='mel')
plt.title('mel power spectrogram (Percussive)')
plt.colorbar(format='%+02.0f dB')

plt.tight_layout()

# # Chromagram - Pitch
C = librosa.feature.chroma_cqt(y=y_harmonic, sr=sr)
plt.figure(figsize=(12,4))
librosa.display.specshow(C, sr=sr, x_axis='time', y_axis='chroma', vmin=0, vmax=1)
plt.title('Chromagram')
plt.colorbar()

plt.tight_layout()

# MFCC - Timpre
mfcc = librosa.feature.mfcc(S=log_S, n_mfcc=13)
delta_mfcc  = librosa.feature.delta(mfcc)
delta2_mfcc = librosa.feature.delta(mfcc, order=2)

plt.figure(figsize=(12, 6))

plt.subplot(3,1,1)
librosa.display.specshow(mfcc)
plt.ylabel('MFCC')
plt.colorbar()

plt.subplot(3,1,2)
librosa.display.specshow(delta_mfcc)
plt.ylabel('MFCC-$\Delta$')
plt.colorbar()

plt.subplot(3,1,3)
librosa.display.specshow(delta2_mfcc, sr=sr, x_axis='time')
plt.ylabel('MFCC-$\Delta^2$')
plt.colorbar()

plt.tight_layout()

M = np.vstack([mfcc, delta_mfcc, delta2_mfcc])

# Beat Tracking
tempo, beats = librosa.beat.beat_track(sr=sr, onset_envelope=librosa.onset.onset_strength(y=y_percussive, sr=sr), trim=False)

# Beat-synchronous feature aggregation - MFCC
M_sync = librosa.util.sync(M, beats)

plt.figure(figsize=(12,6))
plt.subplot(2,1,1)
librosa.display.specshow(M)
plt.title('MFCC-$\Delta$-$\Delta^2$')

plt.yticks(np.arange(0, M.shape[0], 13), ['MFCC', '$\Delta$', '$\Delta^2$'])
plt.colorbar()

plt.subplot(2,1,2)
librosa.display.specshow(M_sync, x_axis='time', x_coords=librosa.frames_to_time(librosa.util.fix_frames(beats)))

plt.yticks(np.arange(0, M_sync.shape[0], 13), ['MFCC', '$\Delta$', '$\Delta^2$'])             
plt.title('Beat-synchronous MFCC-$\Delta$-$\Delta^2$')
plt.colorbar()

plt.tight_layout()

# Beat-synchronous feature aggregation - Chroma
C_sync = librosa.util.sync(C, beats, aggregate=np.median)

plt.figure(figsize=(12,6))

plt.subplot(2,1,1)
librosa.display.specshow(C, sr=sr, y_axis='chroma', vmin=0.0, vmax=1.0, x_axis='time')
plt.title('Chroma')
plt.colorbar()

plt.subplot(2,1,2)
librosa.display.specshow(C_sync, y_axis='chroma', vmin=0.0, vmax=1.0, x_axis='time', x_coords=librosa.frames_to_time(librosa.util.fix_frames(beats)))
plt.title('Beat-synchronous Chroma (median aggregation)')
plt.colorbar()
plt.tight_layout()

# Beat-synchronous feature aggregation - Loudness

CQT = librosa.cqt(y, sr=sr, fmin=librosa.note_to_hz('A1'))
freqs = librosa.cqt_frequencies(CQT.shape[0], fmin=librosa.note_to_hz('A1'))
perceptual_CQT = librosa.perceptual_weighting(CQT**2, freqs, ref=np.max)
CQT_sync = librosa.util.sync(perceptual_CQT, beats, aggregate=np.median)

plt.figure(figsize=(12,6))
plt.subplot(3,1,1)
librosa.display.specshow(librosa.amplitude_to_db(CQT, ref=np.max), fmin=librosa.note_to_hz('A1'), y_axis='cqt_hz')
plt.title('Log CQT power')
plt.colorbar(format='%+2.0f dB')

plt.subplot(3,1,2)
librosa.display.specshow(perceptual_CQT, y_axis='cqt_hz', fmin=librosa.note_to_hz('A1'), x_axis='time')
plt.title('Perceptually weighted log CQT')
plt.colorbar(format='%+2.0f dB')

plt.subplot(3,1,3)
librosa.display.specshow(CQT_sync, y_axis='cqt_hz', fmin=librosa.note_to_hz('A1'), x_axis='time', x_coords=librosa.frames_to_time(librosa.util.fix_frames(beats)))
plt.title('Perceptually weighted log CQT (mean aggregation)')
plt.colorbar(format='%+2.0f dB')

plt.tight_layout()
plt.show()

# print("Feature aggregation: ")
# intensity_frames = np.matrix(CQT_sync).getT()
# print("Shape of Intensity spectogram: ")
# print(intensity_frames.shape)
# pitch_frames = np.matrix(C_sync).getT()
# print("Shape of Pitch spectogram: ")
# print(pitch_frames.shape)
# timbre_frames = np.matrix(M_sync).getT()
# print("Shape of Timbre spectogram: ")
# print(timbre_frames.shape)

# for beat in range(len(beats)):
# 	print("Frame: " + str(beat))
# 	intensity_frame = np.array(intensity_frames[beat,:])[0]
# 	print(" - Mean intensity: " + str(np.mean(intensity_frame)))
# 	pitch_frame = np.array(pitch_frames[beat,:])[0]
# 	print(" - Mean pitch: " + str(np.mean(pitch_frame)))
# 	timbre_frame = np.array(timbre_frames[beat,:])[0]
# 	print(" - Mean timbre: " + str(np.mean(timbre_frame)))

# 	frame_time = 0
# 	if (beat == 0):
# 		frame_time = str(librosa.frames_to_time(beats, sr=sr)[0])
# 	else:
# 		frame_time = librosa.frames_to_time(beats, sr=sr)[beat] - librosa.frames_to_time(beats, sr=sr)[beat - 1]
# 	print(" - Frame time (tempo): " + str(frame_time))

# 	csv_writer.writerow({'name': audio_name, 'frame': beat, 'intensity_spectrum': intensity_frame, 'pitch_spectrum': pitch_frame, 'timbre_spectrum': timbre_frame, 'frame_time': frame_time})

