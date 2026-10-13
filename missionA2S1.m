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
T = samples/fs;
timeVector = linspace(0, T, samples + 1); % trial to see if it helps the time domain plot. 
timeVector(end) = [];

% Create a frequency vector

fA = linspace(-fs/2, fs/2, samples + 1);
fA(end) = [];

% Convert to the frequency domain
%frequencySpectrum = fftshift(fft(audioMultiplexNoisy)) / samples;
AudioMultiplexNoisy_f = normalised_fft(audioMultiplexNoisy);

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
plot(fA, amp2dB(abs(fftshift(AudioMultiplexNoisy_f))));
title('audioMultiplexNoisy in Frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
ylim([-150 0])
grid on;

% There are 5 carrier frequencies in the frequency domain.  The plot above
% shows the frequency spikes at [8210, 24190, 40210, 56290, 72160]

%% Section 1.2 with function block
%Set the cutoff frequency for each carrier frequency
cutoffFreq1 = 4700;
cutoffFreq2 = 8600;
cutoffFreq3 = 8600;
cutoffFreq4 = 6500;
cutoffFreq5 = 8500;

% Using assignment 1 multiplexed system
demultiplex = fft(audioMultiplexNoisy) / fs;

% Define carrier frequency
CF1 = 8210;  %8210      
CF2 = 24190; %24190
CF3 = 40210; %40210
CF4 = 56290; %56290
CF5 = 72160; %72160

% Output the functions for each carrier frequency
[C1, demod1, audioreceived1, audioReceivedFreq1] = ...
    carrierFreq(CF1, timeVector, audioMultiplexNoisy, cutoffFreq1, fs);
[C2, demod2, audioreceived2, audioReceivedFreq2] = ...
    carrierFreq(CF2, timeVector, audioMultiplexNoisy, cutoffFreq2, fs);
[C3, demod3, audioreceived3, audioReceivedFreq3] = ...
    carrierFreq(CF3, timeVector, audioMultiplexNoisy, cutoffFreq3, fs);
[C4, demod4, audioreceived4, audioReceivedFreq4] = ...
    carrierFreq(CF4, timeVector, audioMultiplexNoisy, cutoffFreq4, fs);
[C5, demod5, audioreceived5, audioReceivedFreq5] = ...
    carrierFreq(CF5, timeVector, audioMultiplexNoisy, cutoffFreq5, fs);

%% 1.2 Plotting 
% Make an array of plotting values
plotFreq = {audioReceivedFreq1, audioReceivedFreq2, audioReceivedFreq3, ...
    audioReceivedFreq4, audioReceivedFreq5};

plotTime = {audioreceived1, audioreceived2, audioreceived3, ...
    audioreceived4, audioreceived5};

plotCutoff = {cutoffFreq1, cutoffFreq2, cutoffFreq3, cutoffFreq4, ...
    cutoffFreq5};

plot1_2 = cell(1, 5); % ? is this ever used?

for i = 1:5

    figure;
    subplot(2, 1, 1);
    plot(fA, amp2dB(abs(fftshift(plotFreq{i}))));
    title(['Frequency Domain Plot of Carrier #' num2str(i)]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    xlim([-2e4, 2e4]);
    ylim([-110 -20])
    grid on;

    subplot(2, 1, 2);
    plot(timeVector, plotTime{i});
    title(['Time Domain Plot of Carrier #' num2str(i)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

end 

%% 1.2 Carrier 1 listen
% Listen to the sound of 8210 Hz
sound(audioreceived1, fs);

%% 1.2 Carrier 2 listen
% Listen to the sound of 24190 Hz
sound(audioreceived2, fs);

%% 1.2 Carrier 3 listen
% Listen to the sound of 40210 Hz
sound(audioreceived3, fs);

%% 1.2 Carrier 4 listen
% Listen to the sound of 56290 Hz
sound(audioreceived4, fs);

%% 1.2 Carrier 5 listen
% Listen to the sound of 72160 Hz
sound(audioreceived5, fs);

%% Section 1.3
% Create an impulse
impulseAudio = [fs, zeros(1, samples - 1)];

%Use the channel feature to model the impulse response 
channelIR_t = channel(sid, impulseAudio, fs);

%Find the frequency response and create the frequency vector 
ChannelIR_f = normalised_fft(channelIR_t);


%Plotting both the magnitude spectrum and multiplexed audio on the same
% graph
figure;
hold on;
plot(fA, amp2dB(abs(fftshift(ChannelIR_f))));
plot(fA, amp2dB(abs(fftshift(AudioMultiplexNoisy_f))), '--');
title('Channel Frequency response and audioMultiplexNoisy');
xlabel('Frequency Hz');
ylabel('Magnitude');
legend('Channel frequency response', 'Audio multiplex spectrum');
%ylim([0, 0.2]);
%xlim([0, 0.05]);
grid on;
hold off;
%% Section 1.4
samples =  length(audioMultiplexNoisy);

% This code is unnecessary -- channelFreq is already the same thing.

% Convert the channel impulse from section 1.3 into the frequency domain 
%frequencyRev = fft(channelOutput, samples); %/ fs;

% This is also unnecessary -- audioMultiplexNoisy has already been
% transformed into the frequency domain...

% Convert the audio channel into the frequency domain 
% revfft = fft(audioMultiplexNoisy, samples); %/ fs;

% Reverse channel distortion
revdistAudio = AudioMultiplexNoisy_f ./ ChannelIR_f;
audioequalised_t = ifft(revdistAudio) * fs;




% Demodulate the individual signals into cleanAudio

[C1, demod1, audioclean1_t, audioclean1_f] = ...
    carrierFreq(CF1, timeVector, audioequalised_t, cutoffFreq1, fs);
[C2, demod2, audioclean2_t, audioclean2_f] = ...
    carrierFreq(CF2, timeVector, audioequalised_t, cutoffFreq2, fs);
[C3, demod3, audioclean3_t, audioclean3_f] = ...
    carrierFreq(CF3, timeVector, audioequalised_t, cutoffFreq3, fs);
[C4, demod4, audioclean4_t, audioclean4_f] = ...
    carrierFreq(CF4, timeVector, audioequalised_t, cutoffFreq4, fs);
[C5, demod5, audioclean5_t, audioclean5_f] = ...
    carrierFreq(CF5, timeVector, audioequalised_t, cutoffFreq5, fs);



% % Create a function for reverse distortion
% function [demRevSignal, cleanAudio, CleanAudio]...
%     = reverseDistortion(freq, revAudioEqualised, cutoffFreq, fs, timeVector)
% 
%     % Reverse the channel distortion of the multiplexed signal
%     c = cos(2*pi*freq*timeVector);
%     demRevSignal = revAudioEqualised.* c;
%     cleanAudio = lowpass(demRevSignal, cutoffFreq, fs, 'Steepness', 0.99);
%     cleanAudio = cleanAudio - mean(cleanAudio);
%     CleanAudio = cleanAudio / max(abs(cleanAudio));
% 
% end 

% [demRevSignal1, cleanAudio1, CleanAudio1]...
%     = reverseDistortion(CF1, revAudioEqualised, cutoffFreq1, fs, timeVector);
% [demRevSignal2, cleanAudio2, CleanAudio2]...
%     = reverseDistortion(CF2, revAudioEqualised, cutoffFreq2, fs, timeVector);
% [demRevSignal3, cleanAudio3, CleanAudio3]...
%     = reverseDistortion(CF3, revAudioEqualised, cutoffFreq3, fs, timeVector); 
% [demRevSignal4, cleanAudio4, CleanAudio4]...
%     = reverseDistortion(CF4, revAudioEqualised, cutoffFreq4, fs, timeVector);
% [demRevSignal5, cleanAudio5, CleanAudio5]...
%     = reverseDistortion(CF5, revAudioEqualised, cutoffFreq5, fs, timeVector);

%% 1.4 Plotting 
% Make an array of plotting values

% audioclean_tN1 = normaliseaudio(audioclean1_t);

plot1_4 = {audioclean1_t, audioclean2_t, audioclean3_t, ...
    audioclean4_t, audioclean5_t};

for i = 1:5

    figure;
    subplot(2, 1, 1);
    plot(fA, amp2dB(abs(fftshift(fft(plot1_4{i}) / samples))));
    title('Equalised signal in frequency domain');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    xlim([-2e4, 2e4]);
    ylim([-180 -20])
    grid on;

    subplot(2, 1, 2);
    plot(timeVector, plot1_4{i});
    title('Equalised signal in time domain');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

end 
%% Section 1.4 CF1 
%Listen to audio signal 
sound(audioclean1_t, fs);

%% Section 1.4 CF2 
%Listen to audio signal 
sound(audioclean2_t, fs);

%% Section 1.4 CF3 
%Listen to audio signal 
sound(audioclean3_t, fs);

%% Section 1.4 CF4 
%Listen to audio signal 
sound(audioclean4_t, fs);

%% Section 1.4 CF5 
%Listen to audio signal 
sound(audioclean5_t, fs);

%% Section 1.5 
% Set the cutoff frequency
cutofffreq = 4000; 
carrFreqArray = [8210, 24190, 40210, 56290, 72160]; 

impulseAudio = audioequalised_t(:); 
impulseLength = length(impulseAudio); 

% Create a time vector
time = linspace(0, T, impulseLength + 1);
time(end) = [];

% Create a frequency vector
freqVec = linspace(-fs/2, fs/2, impulseLength + 1);
freqVec(end) = [];
freqVec = freqVec';

% Create a for loop to modulate all carrier frequencies
cleanAudio = cell(1, 5); 

for i = 1:5
    % Create a vector with the cut off frequency
    passband = [carrFreqArray(i) - cutofffreq, carrFreqArray(i) + cutofffreq];
    
    % Use a bandpass filter to isolate clean audio
    audioBand = bandpass(impulseAudio, passband, fs);    

    % Modulate the audio to 0Hz with the carrier modulation
    c = cos(2*pi*carrFreqArray(i)*time);
    c = c (:);
    demsignal = audioBand .* c;    
 
    % Take the full signal into the frequency domain
    ZeroShift = fftshift(fft(demsignal)); 

   % From analysing all the plots in section 1.4 it was identified that
   % all the carrier frequencies had noise from 2200 - 2900 Hz
    noiseSpike = 2600; 
    tolerance = 400; 

    % Adjust vector to remove noisy signals
    noiseSpikes = (abs(freqVec) >= (noiseSpike - tolerance)) & ...
        (abs(freqVec) <= (noiseSpike + tolerance));  
    ZeroShift(noiseSpikes) = 0; % Zero out noisy freq

    figure
    plot(freqVec, amp2dB(abs(ZeroShift)));
    title('Final Audio in the Frequency Domain');
    xlabel('Frequency Hz');
    ylabel('Magnitude dB');
    grid on;
    xlim([-cutofffreq, cutofffreq]);

    % Convert Back to the time domain
    finalTime = ifft(ifftshift(ZeroShift));

    % Step 4: Lowpass filter the reconstructed signal to clean up edges
    cleanAudio{i} = lowpass(finalTime, cutofffreq, fs);
       
end

%% Alternate Approach

plot1_5 = {audioclean1_f, audioclean2_f, audioclean3_f, audioclean4_f, ...
    audioclean5_f};

for i = 1:5

figure()
subplot(2,1,1)
plot(fA, abs(fftshift(plot1_5{i})));
hold on
subplot(2,1,2)
plot(fA, amp2dB(abs(fftshift(plot1_5{i}))));

end

% Frequency with which we search above for single-tone components
initial_f = 2000;


fftshifted = abs(fftshift(audioclean1_f));
delta_f = fs/length(fA);
DC_OHz = 1920001;
freqbin(DC_OHz, 2978);

removetones(input, fA, initial_f)

for i = 1:length(fA)
    if abs(fA(i)) > initial_f
        if abs(fftshifted(i)) > 0.02
            removefreq = i; 
            disp(i)
        end
    end
end    

    

%% Play the desired audio for carrier Freq 1 
ChooseAudio = cleanAudio{1};
FinalAudio = ChooseAudio / max(abs(ChooseAudio));
sound(FinalAudio, fs);

%% Play the desired audio for carrier Freq 2
ChooseAudio = cleanAudio{2};
FinalAudio = ChooseAudio / max(abs(ChooseAudio));
sound(FinalAudio, fs);

%% Play the desired audio for carrier Freq 3
ChooseAudio = cleanAudio{3};
FinalAudio = ChooseAudio / max(abs(ChooseAudio));
sound(FinalAudio, fs);

%% Play the desired audio for carrier Freq 4
ChooseAudio = cleanAudio{4};
FinalAudio = ChooseAudio / max(abs(ChooseAudio));
sound(FinalAudio, fs);

%% Play the desired audio for carrier Freq 5
ChooseAudio = cleanAudio{5};
FinalAudio = ChooseAudio / max(abs(ChooseAudio));
sound(FinalAudio, fs);

%% Function definitions

% Converting amplitudes to decibels.
function AdB = amp2dB(A)

AdB = 20*log10(A + eps);

end

% A function for performing normalized fast fourier transforms.
function nfft = normalised_fft(signal)

nfft = fft(signal) / length(signal);

end
 
% Function for modulation of carrier frequencies using cos(2*pi*f*t).
function [c, demodulatedSignal, audioReceived, audioReceivedFreq] = ... 
    carrierFreq(freq, timeVector, signal, cutoffFreq, fs)

c = cos(2*pi*freq*timeVector);
demodulatedSignal = signal.* c;
audioReceived = lowpass(demodulatedSignal, cutoffFreq, fs, 'Steepness',0.99);
audioReceived = audioReceived - mean(audioReceived);
audioReceivedFreq = normalised_fft(audioReceived);

end 

% Normalisation

function NormalisedAudio = normaliseaudio(inputsignal)

    NormalisedAudio = inputsignal / max(abs(inputsignal));

end

function frequency_bin = freqbin(dcvalue, frequency)

    frequency_bin = dcvalue + frequency/0.05;

end

% Function for finding single-tone frequencies

function cleaned_signal = removetones(input, fA, initial_f, threshold)

    % input must be shifted for following arithmetic to function correctly
    fftshifted = abs(fftshift(input));

    % for the length of the supplied frequency vector
    for i = 1:length(fA)
        % if the absolute value of the indexed frequency is greater than
        % the supplied initial frequency 
        if abs(fA(i)) > initial_f
            % AND if that indexed value is greater than the threshold 
            if abs(fftshifted(i)) > threshold
                removefreq = i;
                % currently will display the index but I will edit this
                % to remove it instead
                disp(i)
            end
        end
    end

end