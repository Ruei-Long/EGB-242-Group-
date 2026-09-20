%% EGB242 Assignment 2, Section 1 %%
% This file is a template for your MATLAB solution to Section 1.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 audioMultiplexNoisy fs sid;

% Begin writing your MATLAB solution below this line.R

%% Section 1.1 plot audioMultiplexNoisy in frequency and time domain
%Create a time vector
samples = length(audioMultiplexNoisy);
timeVector = (0:samples-1) / fs;

% Create a frequency vector
freq = linspace(-fs/2, fs/2, samples + 1);
freq(end) = [];

% Plot the time domain vector
figure;
plot(timeVector, audioMultiplexNoisy);
title('audioMultiplexNoisy vs time domain');
xlabel('Time(s)');
ylabel('Amplitude');
grid on;

% plot in the frequency spectrum
figure;
plot(freq, audioMultiplexNoisy);
title('audioMultiplexNoisy vs Frequency spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

%% Section 1.2 
% Using assignment 1 multiplexed system
demultiplex = fft(audioMultiplexNoisy) / fs;

figure;
plot(freq, abs(fftshift(demultiplex)));  
title('Magnitude Spectrum of Multiplexed Noisy Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% There are 5 carrier frequencies

%% Select required carrier frequency in preparation for modulation
carrierFreq = %select when code runs properly
carrierModulation = cos(2 * pi * carrierFreq * samples);

% Demodulate the audio signal
demodulatedSignal = audioMultiplexNoisy.*carrierModulation;

% Apply low pass filtering to reduce signal noise
cutoffFreq = % Selected cut off noise when code runs
audioRecieved = lowpass(demulatedSignal, cutoffFreq, fs);

% Normalise the audio signal 
audioRecieved = audioRecieved / mas(abs(audioRecieved));

% Listen to multiplexed audio
sound(real(audioRecieved));


%% Section 1.3
y = channel(sid1, x, fs);