"""PyAudio Example: Record a few seconds of audio and save to a wave file."""

import wave
import queue
import pyfftw
import numpy
import pyaudio
import pyloudnorm
from scipy.io.wavfile import read, write
from scipy.signal import decimate

from matplotlib import pyplot as plt

CHUNK = 8192
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
RECORD_SECONDS = 5

meter = pyloudnorm.Meter(rate=RATE, block_size=8192/44100)


p = pyaudio.PyAudio()

stream = p.open(format=FORMAT, channels=CHANNELS, rate=RATE, input=True)
numpyQueue = queue.Queue(2)

isFull = False
halfwayDone = False
isDone = False
while not isDone:
    if not isFull and numpyQueue.full():
        isFull = True
    if isFull:
        numpyQueue.get()
    chunkData = numpy.frombuffer(stream.read(CHUNK), dtype=numpy.int16)
    numpyQueue.put(chunkData)
    if (halfwayDone):
        isDone = True
    elif meter.integrated_loudness(chunkData.astype(numpy.float64)) > 83.0:
        halfwayDone = True
            
rfftResults = pyfftw.interfaces.scipy_fft.rfft(numpy.concatenate(list(numpyQueue.queue)))
rfftFreq = pyfftw.interfaces.scipy_fft.rfftfreq(16384, 1/44100)
print(rfftFreq)

maxMag = abs(rfftResults[0])
freqToMap = 0
for freqIndex, freqMag in enumerate(rfftResults[1:]):
    absFreqMag = abs(freqMag)
    if (absFreqMag > maxMag):
        maxMag = absFreqMag
        freqToMap = freqIndex


plt.plot(rfftFreq, numpy.abs(rfftResults))
plt.show()
print(rfftFreq[freqToMap])


stream.close()
p.terminate()

# resampledData = decimate(numpyData, 2.75625)

# write("output.wav", RATE*CHANNELS*RECORD_SECONDS, resampledData)
    
# with wave.open('output.wav', 'wb') as wf:
  #  wf.setnchannels(CHANNELS)
   # wf.setsampwidth(p.get_sample_size(FORMAT))
    #wf.setframerate(RATE)
    #wf.writeframes(numpyData)
