%% EGB242 Assignment 2, Section 1 %%
% This file is a template for your MATLAB solution to Section 1.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 audioMultiplexNoisy fs sid;

% Begin writing your MATLAB solution below this line.R
load('DataA2.mat')

%% Section 1.1 plot audioMultiplexNoisy in frequency and time domain
%Create a time vector
samples = length(audioMultiplexNoisy);
timeVector = linspace(0, samples/fs, samples);

% Create a frequency vector
freq = linspace(-fs/2, fs/2, samples + 1);
freq(end) = [];

% Convert to the frequency domain
frequencySpectrum = fftshift(fft(audioMultiplexNoisy)) / samples;

% Plot the time domain vector
figure;
subplot(2,1,2);
plot(timeVector, audioMultiplexNoisy);
title('audioMultiplexNoisy in time domain');
xlabel('Time(s)');
ylabel('Amplitude');
grid on;

% plot in the frequency spectrum
subplot(2,1,1);
plot(freq, abs(frequencySpectrum));
title('audioMultiplexNoisy in Frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% There are 5 carrier frequencies in the frequency domain.  The plot above
% shows the freqency spikes at [8210, 24190, 40210, 56290, 72160]

%% Section 1.2 with function block
%Set the cutoff frequency
cutoffFreq = 4000;

% Using assignment 1 multiplexed system
demultiplex = fft(audioMultiplexNoisy) / fs;

% Define carrier frequency
CF1 = 8210;
CF2 = 24190;
CF3 = 40210;
CF4 = 56290;
CF5 = 72160;

% Create a function to modulate all frequencies using cos(2*pi*f*t);
function [c, demodulatedSignal, audioReceived, ... 
                audioNormal, audioReceivedFreq] = ... 
                carrierFreq(freq, timeVector, signal, cutoffFreq, fs)

    c = cos(2*pi*freq*timeVector);
    demodulatedSignal = signal.* c;
    audioReceived = lowpass(demodulatedSignal, cutoffFreq, fs);
    audioNormal = audioReceived/ max(abs(audioReceived));
    audioReceivedFreq = fft(audioReceived) / fs;

end 

% Output the functions for each carrier frequency
[C1, demod1, audioreceived1, audioNormal1, audioReceivedFreq1] = ...
    carrierFreq(CF1, timeVector, audioMultiplexNoisy, cutoffFreq, fs);
[C2, demod2, audioreceived2, audioNormal2, audioReceivedFreq2] = ...
    carrierFreq(CF2, timeVector, audioMultiplexNoisy, cutoffFreq, fs);
[C3, demod3, audioreceived3, audioNormal3, audioReceivedFreq3] = ...
    carrierFreq(CF3, timeVector, audioMultiplexNoisy, cutoffFreq, fs);
[C4, demod4, audioreceived4, audioNormal4, audioReceivedFreq4] = ...
    carrierFreq(CF4, timeVector, audioMultiplexNoisy, cutoffFreq, fs);
[C2, demod5, audioreceived5, audioNormal5, audioReceivedFreq5] = ...
    carrierFreq(CF5, timeVector, audioMultiplexNoisy, cutoffFreq, fs);

sound(audioreceived1, fs);
%sound(audioreceived2, fs);
%sound(audioreceived3, fs);
%sound(audioreceived4, fs);
%sound(audioreceived5, fs);


%% 1.2 plot frequency 8210
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq1)));
title('Frequency 1 8210 Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioreceived1);
title('Time domain of 8210Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;

%% 1.2 plot frequency 24190 
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq2)));
title('Frequency 1 24190 Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioreceived2);
title('Time domain of 24190 Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;

%% 1.2 plot frequency 40210 
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq3)));
title('Frequency 1 40210 Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioreceived3);
title('Time domain of 40210 Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
%% 1.2 plot frequency 56290 
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq4)));
title('Frequency 1 56290 Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioreceived4);
title('Time domain of 56290 Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
%% 1.2 plot frequency 72160 
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(audioRecievedFreq5)));
title('Frequency 1 72160 Hz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-4000, 4000]);
grid on;

subplot(2, 1, 2);
plot(timeVector, audioreceived5);
title('Time domain of 72160 Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
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

%Discuss the offset of the DC should be symetrical around 0. Look at the offset that is in the time domain.   
% Look at 3000Hz at each point in the plot. Look at cutting the frequency
% down around this point
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
%sound(real(audioRecieved2), fs);

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
% sound(real(audioRecieved3), fs);

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

% Time domain is not straight.
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
%sound(real(audioRecieved4), fs);

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
plot(timeVector, audioRecieved4);
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
%sound(real(audioRecieved5), fs);

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
plot(timeVector, audioRecieved5);
title('Time domain of 72160Hz');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
%% Section 1.3
% See tutorial 7 for a way to complete this assignment. 
% Define time period 
ts = 1/fs;

% Create an impulse
impulse = [(1/ts), zeros(1, 49)];

% Create round values for vectors
sid = round(sid);
fs = round(fs);

% Need to transfer the h function with the f(t)

%Use the channel feature to model the impulse response 
channelOutput = channel(sid, impulse, fs);

%Find the frequency response and create the frequency vector 
channelFreq = fftshift(fft(channelOutput)) / fs;
channelFrequency = linspace(-fs/2, fs/2, length(channelOutput) + 1);
channelFrequency(end) = [];

%Plotting both the magnitude spectrum and multiplexed audio on the same
%graph
figure;
hold on;

%Labelling and title of the graph
title('Channel Frequency response and audioMultiplexNoisy');
xlabel('Frequency Hz');
ylabel('Magnitude');

%Plotted data
plot(channelFrequency, abs(channelFreq), 'LineWidth', 1.2);
plot(freq, abs(frequencySpectrum), '--');
legend('Channel frequency response', 'Audio multiplex spectrum');
grid on;

% Use these limits to inspect sections of the plot. 
%ylim([0, 0.05]);
%xlim([0, 0.05]);
hold off;

%% Section 1.4 
% Reverse distorion for frequency 1 
frequencyRev = fft(channelOutput, samples) / fs;

% Create the frequency domain vector
revfft = fft(audioMultiplexNoisy) / fs;

% Equalise the reversed frequency domain
revAudio = revfft ./ frequencyRev;

% Convert to the time domain
revAudioEqualized = ifft(revAudio) * fs;

% Demodulate the frequency
demRevSignal = revAudioEqualized .* carrierModulation;
cleanAudio = lowpass(demRevSignal, cutoffFreq, fs);
cleanAudio = cleanAudio / max(abs(cleanAudio));

% Listen to the denoised audio 
%sound(cleanAudio, fs);

% Plot equalised signal in time and frequency domains
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(fft(cleanAudio) / samples)));
title('Equalised signal in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-cutoffFreq, cutoffFreq]);
grid on;

subplot(2, 1, 2);
plot(timeVector, cleanAudio);
title('Equalised signal in time domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Section 1.4 frequency 2 
% Reverse distorion for frequency 2 
demRevSignal2 = revAudioEqualized .* carrierModulation2;
cleanAudio2 = lowpass(demRevSignal2, cutoffFreq, fs);
cleanAudio2 = cleanAudio2 / max(abs(cleanAudio2));

% Listen to the denoised audio 
%sound(cleanAudio2, fs);

% Plot equalised signal in time and frequency domains
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(fft(cleanAudio2) / samples)));
title('Equalised signal in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-cutoffFreq, cutoffFreq]);
grid on;

subplot(2, 1, 2);
plot(timeVector, cleanAudio2);
title('Equalised signal in time domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Section 1.4 frequency 3 
% Reverse distorion for frequency 3 
demRevSignal3 = revAudioEqualized .* carrierModulation3;
cleanAudio3 = lowpass(demRevSignal3, cutoffFreq, fs);
cleanAudio3 = cleanAudio3 / max(abs(cleanAudio3));

% Listen to the denoised audio 
%sound(cleanAudio3, fs);

% Plot equalised signal in time and frequency domains
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(fft(cleanAudio3) / samples)));
title('Equalised signal in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-cutoffFreq, cutoffFreq]);
grid on;

subplot(2, 1, 2);
plot(timeVector, cleanAudio3);
title('Equalised signal in time domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
%% Section 1.4 frequency 4 
% Reverse distorion for frequency 4 
demRevSignal4 = revAudioEqualized .* carrierModulation4;
cleanAudio4 = lowpass(demRevSignal4, cutoffFreq, fs);
cleanAudio4 = cleanAudio4 / max(abs(cleanAudio4));

% Listen to the denoised audio 
%sound(cleanAudio4, fs);

% Plot equalised signal in time and frequency domains
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(fft(cleanAudio4) / samples)));
title('Equalised signal in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-cutoffFreq, cutoffFreq]);
grid on;

subplot(2, 1, 2);
plot(timeVector, cleanAudio4);
title('Equalised signal in time domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Check the carrier frequency.
%% Section 1.4 frequency 5 
% Reverse distorion for frequency 5 
demRevSignal5 = revAudioEqualized .* carrierModulation5;
cleanAudio5 = lowpass(demRevSignal5, cutoffFreq, fs);
cleanAudio5 = cleanAudio5 / max(abs(cleanAudio5));

% Listen to the denoised audio 
%sound(cleanAudio5, fs);

% Plot equalised signal in time and frequency domains
figure;
subplot(2, 1, 1);
plot(freq, abs(fftshift(fft(cleanAudio5) / samples)));
title('Equalised signal in frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-cutoffFreq, cutoffFreq]);
grid on;

subplot(2, 1, 2);
plot(timeVector, cleanAudio5);
title('Equalised signal in time domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
%% Section 1.5
% Create a frequency shift of the demodulated audio
CleanAudio = fftshift(fft(cleanAudio));

% Find the frequency resolution to represent the spacing between the frequency spikes
% in the audio singal
df = fs / length(cleanAudio);

% Find the base indexes for 0 Hz, +3000 Hz, and -3000 Hz
indexDC = round(length(CleanAudio) / 2) + 1;
indexPositive3000Hz = indexDC + round(3000 / df);
indexNegative3000Hz = indexDC - round(3000 / df);

% Set a spike width for removal
spikeWidth = 2;

% Remove the 0 Hz DC offset point
CleanAudio(indexDC) = 0;

% Clear the positive 3000 Hz spike range
PositiveStart = indexPositive3000Hz - spikeWidth;
PositiveEnd   = indexPositive3000Hz + spikeWidth;
CleanAudio(PositiveStart : PositiveEnd) = 0;

% Clear the negative 3000 Hz spike range
NegativeStart = indexNegative3000Hz - spikeWidth;
NegativeEnd = indexNegative3000Hz + spikeWidth;
CleanAudio(NegativeStart : NegativeEnd) = 0;

% Convert the cleaned spectrum back into a time-domain sound signal
finalAudio = ifft(CleanAudio);

% Normalise the final audio signal
finalAudio = finalAudio / max(abs(finalAudio));

% Listen to the clean audio signal
sound(finalAudio, fs);

% Plot in the time and frequency domain
% Frequency domain
figure;
subplot(2, 1, 1);
plot(freq, abs(fft(finalAudio) / samples));
title('De-noised Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
% xlim([-cutoffFreq, cutoffFreq]); 
grid on;

% Time domain
subplot(2, 1, 2);
plot(timeVector, finalAudio);
title('De-noised Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Have I removed the signal rather than the noise? 
% This appears to be fft shifted. 
