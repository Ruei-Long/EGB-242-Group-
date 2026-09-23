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
timeVector = linspace(0, samples/fs, samples);

% Create a frequency vector
freq = linspace(-fs/2, fs/2, samples + 1);
freq(end) = [];

% Convert to the frequency domain
frequencySpectrum = fftshift(fft(audioMultiplexNoisy)) / fs;

% Plot the time domain vector
figure;
plot(timeVector, audioMultiplexNoisy);
title('audioMultiplexNoisy in time domain');
xlabel('Time(s)');
ylabel('Amplitude');
grid on;

% plot in the frequency spectrum
figure;
plot(freq, abs(frequencySpectrum));
title('audioMultiplexNoisy in Frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% There are 5 carrier frequencies in the frequency domain.  The plot above
% shows the freqency spikes at [8210, 24190, 40210, 56290, 72160]

%% Section 1.2 
% In order to cut off any negative frequency from the frequency plot above
% a lowpass filter was applied to cut off any small signal and negative
% signals. 
cutoffFreq = 4000;

% Using assignment 1 multiplexed system
demultiplex = fft(audioMultiplexNoisy) / fs;

% Select required carrier frequency in preparation for modulation
freq1 = 8210;

% Using the fourier transform pinciple, create a variable for modulation.
carrierModulation = cos(2 * pi * freq1 * timeVector);

% Demodulate the audio signal
demodulatedSignal1 = audioMultiplexNoisy.*carrierModulation;

% Apply low pass filtering to reduce signal noise
audioRecieved1 = lowpass(demodulatedSignal1, cutoffFreq, fs);

% Normalise the audio signal 
audioRecieved1 = audioRecieved1 / max(abs(audioRecieved1));

% Bring freq1 into the frequency domain
audioRecievedFreq1 = fft(audioRecieved1) / fs;

% Listen to multiplexed audio
sound(audioRecieved1, fs);

% This frequency has high pitched noise in the background with a small
% amount of music.  This sound simulates the background noise that could be
% heard within the mars space shuttle. 

figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq1)));
title('Frequency 1 8210 Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioRecieved1);
title('Time domain of 8210Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;

%% Section 1.2 frequency 2
% Select required carrier frequency in preparation for modulation
freq2 = 24190;

% Using the fourier transform pinciple, create a variable for modulation.
carrierModulation2 = cos(2 * pi * freq2 * timeVector);

% Demodulate the audio signal
demodulatedSignal2 = audioMultiplexNoisy.*carrierModulation2;

% Apply low pass filtering to reduce signal noise
audioRecieved2 = lowpass(demodulatedSignal2, cutoffFreq, fs);

% Normalise the audio signal 
audioRecieved2 = audioRecieved2 / max(abs(audioRecieved2));

% Bring freq2 into the frequency domain
audioRecievedFreq2 = fft(audioRecieved2) / fs;

% Listen to multiplexed audio
sound(real(audioRecieved2), fs);

% This audio signal is a lower frequency noise of the mars shuttle in
% transport.  There is a faint music in the background. 

figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq2)));
title('Frequency 2 24190Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioRecieved2);
title('Time domain of 24190Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;


%% Section 1.2 frequency 3
% Select required carrier frequency in preparation for modulation
freq3 = 40210;

% Using the fourier transform pinciple, create a variable for modulation.
carrierModulation3 = cos(2 * pi * freq3 * timeVector);

% Demodulate the audio signal
demodulatedSignal3 = audioMultiplexNoisy.*carrierModulation3;

% Apply low pass filtering to reduce signal noise
audioRecieved3 = lowpass(demodulatedSignal3, cutoffFreq, fs);

% Normalise the audio signal 
audioRecieved3 = audioRecieved3 / max(abs(audioRecieved3));

% Bring freq3 into the frequency domain
audioRecievedFreq3 = fft(audioRecieved3) / fs;

% Listen to multiplexed audio
sound(real(audioRecieved3), fs);

% This is a high pitched background noise with smooth music in the
% background. 

figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq3)));
title('Frequency 3 40210Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioRecieved3);
title('Time domain of 40210Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;

%% Section 1.2 frequency 4
% Select required carrier frequency in preparation for modulation
freq4 = 56290;

% Using the fourier transform pinciple, create a variable for modulation.
carrierModulation4 = cos(2 * pi * freq4 * timeVector);

% Demodulate the audio signal
demodulatedSignal4 = audioMultiplexNoisy.*carrierModulation4;

% Apply low pass filtering to reduce signal noise
audioRecieved4 = lowpass(demodulatedSignal4, cutoffFreq, fs);

% Normalise the audio signal 
audioRecieved4 = audioRecieved4 / max(abs(audioRecieved4));

% Bring freq3 into the frequency domain
audioRecievedFreq4 = fft(audioRecieved4) / fs;

% Listen to multiplexed audio
sound(real(audioRecieved4), fs);

% High pitched noise simulating the background noise of the space shuttle.

figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq4)));
title('Frequency 4 56290Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioRecieved3);
title('Time domain of 56290Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;

%% Section 1.2 frequency 5
% Select required carrier frequency in preparation for modulation
freq5 = 72160;

% Using the fourier transform pinciple, create a variable for modulation.
carrierModulation5 = cos(2 * pi * freq5 * timeVector);

% Demodulate the audio signal
demodulatedSignal5 = audioMultiplexNoisy.*carrierModulation5;

% Apply low pass filtering to reduce signal noise
audioRecieved5 = lowpass(demodulatedSignal5, cutoffFreq, fs);

% Normalise the audio signal 
audioRecieved5 = audioRecieved5 / max(abs(audioRecieved5));

% Bring freq3 into the frequency domain
audioRecievedFreq5 = fft(audioRecieved5) / fs;

% Listen to multiplexed audio
sound(real(audioRecieved5), fs);

% Highest pitched frequency of all 5 signals. 

figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq4)));
title('Frequency 5 72160Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioRecieved3);
title('Time domain of 72160Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
%% Section 1.3
y = channel(sid1, x, fs);