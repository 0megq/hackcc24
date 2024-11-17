from __future__ import annotations
from py4godot.methods import private
from py4godot.classes import gdclass
from py4godot.classes.Node.Node import Node
import aubio
import numpy
import pyaudio
import pyloudnorm

@gdclass
class FrequencyMagic(Node):
	
	@private
	def isFreqMatch(self: Self, inputFreq: float, correctFreq: int) -> bool:
		return (correctFreq * 0.96 < inputFreq and inputFreq < 1.04 * correctFreq)
	
	def isLiveFreqCorrect(self: Self, correctFreq: int) -> bool:
		CHUNK = 1024
		FORMAT = pyaudio.paInt16
		CHANNELS = 1
		RATE = 44100
		TOLERANCE = 0.8
		
		pitch_o = aubio.pitch("yinfft", CHUNK*4, CHUNK, RATE)
		pitch_o.set_unit("Hz")
		pitch_o.set_tolerance(TOLERANCE)

		meter = pyloudnorm.Meter(rate=RATE, block_size=CHUNK/RATE)
		p = pyaudio.PyAudio()
		stream = p.open(format=FORMAT, channels=CHANNELS, rate=RATE, input=True)

		freqMatches = False
		samplesChecked = 0
		loud = False

		while samplesChecked < 6:
			chunkData = numpy.frombuffer(stream.read(CHUNK), dtype=numpy.int16).astype(numpy.float32)
			if (loud):
				print(pitch_o(chunkData))
				if (self.isFreqMatch(pitch_o(chunkData), correctFreq)):
					freqMatches = True
					break
				samplesChecked += 1
			elif meter.integrated_loudness(chunkData) > 70.0:
				print(pitch_o(chunkData))
				loud = True
				if (self.isFreqMatch(pitch_o(chunkData), correctFreq)):
					freqMatches = True
					break
				samplesChecked = 1
		stream.close()
		p.terminate()

		return freqMatches
