import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile

# Load the WAV file
def load_wav(filename):
    sample_rate, data = wavfile.read("output.wav")
    return sample_rate, data

# Perform Fourier Transform and identify frequencies
def identify_frequencies(sample_rate, data):
    # If stereo, take one channel
    if len(data.shape) > 1:
        data = data[:, 0]

    # Normalize the data
    data = data / np.max(np.abs(data))

    # Perform FFT
    fft_result = np.fft.fft(data)
    fft_magnitude = np.abs(fft_result)

    # Frequency values
    freqs = np.fft.fftfreq(len(fft_magnitude), 1/sample_rate)

    return freqs[:len(freqs)//2], fft_magnitude[:len(fft_magnitude)//2]

# Plot the frequency spectrum
def plot_frequencies(freqs, magnitude):
    plt.figure(figsize=(10, 6))
    plt.plot(freqs, magnitude)
    plt.title('Frequency Spectrum')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.grid()
    plt.show()
