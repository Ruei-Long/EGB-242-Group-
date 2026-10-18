%%%% EGB242 Assignment 2, Section 3 %%
% This file is a template for your MATLAB solution to Section 3.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 imagesReceived;

% Begin writing your MATLAB solution below this line.
%% Section 3.1 - original image
[image_in_2D1, image_in_1D1] = received_site_image(imagesReceived, 1); 
imwrite(image_in_2D1, 'image_in_2D1.png');

%% Section 3.2 time & frequency domain before filter
derty_time_domain_1 = Visualise_signal_time(image_in_1D1);
saveas(gcf, 'derty_time_domain.png');
Freq_domain_1 = Visualise_signal_freq(image_in_1D1);
saveas(gcf, 'derty_freq_domain.png');

%% Section 3.3 - filter justification
%frequency response
[H_pass1, Pass1_2D_output] = Passive_filter1(image_in_1D1);
[H_pass2, Pass2_2D_output] = Passive_filter2(image_in_1D1);
[H_act1, Act1_2D_output] = Active_filter1(image_in_1D1);
[H_act2, Act2_2D_output] = Active_filter2(image_in_1D1); 
ltiview(H_pass1, H_pass2, H_act1, H_act2);

%% Section 3.4 display clean image - time & frequency domain
[~, clean_image1] = Active_filter2(image_in_1D1);
clean_image_1 = reshape(clean_image1, 480, 640);
figure;
imshow(clean_image_1);
imwrite(clean_image_1, 'clean_image_1.png');

clean_time_domain_1 = Visualise_signal_time(clean_image1);
saveas(gcf, 'clean_time_domain.png');
clean_freq_domain_1 = Visualise_signal_freq(clean_image1);
saveas(gcf, 'clean_freq_domain.png');

%% Section 3.5 - output and filtering each image
[~, image_in_2D2] = received_site_image(imagesReceived, 2);
imwrite(image_in_2D2, 'image_in_2D2.png');
[~, image_in_2D3] = received_site_image(imagesReceived, 3);
imwrite(image_in_2D3, 'image_in_2D3.png');
[~, image_in_2D4] = received_site_image(imagesReceived, 4);
imwrite(image_in_2D4, 'image_in_2D4.png');

% image 2
[~, clean_image2] = Active_filter1(image_in_2D2);
clean_image_2 = reshape(clean_image2, 480, 640);
figure;
imshow(clean_image_2);
saveas(gcf, 'clean_image2.png');
% image 3
[~, clean_image3] = Active_filter1(image_in_2D3);
clean_image_3 = reshape(clean_image3, 480, 640);
figure;
imshow(clean_image_3);
saveas(gcf, 'clean_image3.png');
% image 4
[~, clean_image4] = Active_filter1(image_in_2D4);
clean_image_4 = reshape(clean_image4, 480, 640);
figure;
imshow(clean_image_4);
saveas(gcf, 'clean_image4.png');

%% Function Definition 
% Extracts a specific 1D image signal from the received matrix 
% and reshapes it into a 2D image for display.
% Inputs:
%   imagesReceived  - 2D matrix containing multiple 1D image signals (each row is one image)
%   image_in_1D_num - Row index specifying which image to extract
% Outputs:
%   image           - Reshaped 2D image matrix (480x640)
%   image_in_1D     - Extracted raw 1D pixel stream
function [image, image_in_1D] = received_site_image(imagesReceived, image_in_1D_num)
    % Pixels are ordered top-to-bottom (column-wise) first, then left-to-right
    tall = 480; % Image height in pixels (number of rows)
    wide = 640; % Image width in pixels (number of columns)
    % Extract the specified 1D image signal (row) from the received matrix
    image_in_1D = imagesReceived(image_in_1D_num, :);
    % Convert (reshape) the 1D pixel stream into a 480x640 2D image matrix
    image = reshape(image_in_1D, tall, wide);
    % Open a new figure window and display the 2D image
    figure;
    imshow(image);
end

% Plots the 1D image signal in the time domain.
% Input:  im1D - 1D image signal array
% Output: t    - Corresponding time vector (in seconds)
% time domain plot
function t = Visualise_signal_time(im1D)
    N = length(im1D);         % Total number of samples (pixels) in the 1D signal (480*640 = 307,200)
    samples_frequency = 1000; % Sampling frequency in Hz (1000 pixels per second)
    % Generate a linearly spaced time vector from 0 to (N-1)/Fs with N points
    t = linspace(0, (N-1)/samples_frequency, N);
    figure;
    plot(t, im1D);
    xlabel("Time (s)", 'fontsize', 20);
    ylabel("Amplitude", 'fontsize', 20);
    xlim([0, 315]);     
    title("Recived Signal in Time Domain", 'fontsize', 20);
    grid on;  
end

% Transforms the 1D signal into the frequency domain using FFT 
% and plots the magnitude spectrum in decibels (dB).
% Input:  im1D - 1D image signal array
% Output: f    - Zero-centered frequency vector (in Hz)
% frequency domain plot
function f = Visualise_signal_freq(im1D)
    N = length(im1D);         % Total number of samples in the signal
    samples_frequency = 1000; % Sampling frequency Fs = 1000 Hz
    % Create a symmetric frequency vector centered at 0 Hz, ranging from -Fs/2 to +Fs/2 (-500 Hz to +500 Hz)
    f = (- N/2 : N/2 - 1) * (samples_frequency / N); % Frequency axis in Hz
    % Compute the Fast Fourier Transform (FFT) and normalize by the signal length N
    X = fft(im1D) / N;
    figure;
    plot(f, amp2dB(abs(fftshift(X))));
    xlabel("Frequency (Hz)", 'fontsize', 20);
    ylabel("Magnitude（dB)", 'fontsize', 20);
    ylim([-90,0]);
    title("Received Signal in Frequency Domain", 'fontsize', 20);
    grid on;
end

% Converts linear amplitude values to a logarithmic decibel (dB) scale.
function AdB = amp2dB(A)
    AdB = 20*log10(A + eps);
end

% value from the task sheet
function [R1, R2, C1, C2, R, C] = filter_value()
    R1 = 1200;
    R2 = 1000;
    C1 = 10e-6;
    C2 = 4.7e-6;
    R = 820;
    C = 1e-6;
end

% Simulates the time-domain response of passing the 1D image signal 
% through a given continuous-time transfer function H(s).
% Inputs:
%   im1D - Raw unfiltered 1D image signal
%   H    - Continuous-time transfer function of the filter
% Output:
%   im2D_output - Filtered 1D output signal (Note: lsim outputs a 1D vector; 
% it must be reshaped later to display as a 2D image)
function im2D_output = Clean_image_output(im1D, H)
    samples_frequency = 1000;
    N = length(im1D);
    t = linspace(0, (N-1)/samples_frequency, N);
    im2D_output = lsim(H,im1D,t);
end

%Passive filter 1 (second order Band pass)
function [H,im2D_output] = Passive_filter1(im1D) 
    % filter value
    s = tf('s'); % Define the Laplace variable 's'
    % Retrieve passive filter component values R1, R2, C1, C2
    [R1, R2, C1, C2,~,~] = filter_value();
    %num = sR1C1
    %den = s^2(R1R2C1C2)+s(R1C1+R1C2+R2C2)+1
    num = R1*C1*s;
    den = s^2*(R1*R2*C1*C2)+s*(R1*C1+R1*C2+R2*C2)+1;
    H = num/den;
    im2D_output = Clean_image_output(im1D, H);
end

%Passive filter 2 (second order lowpass filter)
function [H,im2D_output] = Passive_filter2(im1D) 
    % filter value
    s = tf('s'); % Define the Laplace variable 's'
    % Retrieve passive filter component values R1, R2, C1, C2
    [R1, R2, C1, C2,~,~] = filter_value();
    %num = 1
    %den = s^2(R1R2C1C2)+s(R1C1+R1C2+R2C2)+1
    num = 1;
    den = s^2*(R1*R2*C1*C2)+s*(R1*C1+R1*C2+R2*C2)+1;
    H = num/den;
    im2D_output = Clean_image_output(im1D, H);
end

%Active filter 1 (shellen  key second order active lowpass filter)
function [H,im2D_output] = Active_filter1(im1D)
    % filter value
    s = tf('s'); % Define the Laplace variable 's'
    % Retrieve R and C values for the active filter
    [~,~,~,~,R,C] = filter_value();
    %num = 1/(RC)^2
    %den = s^2+2*s/RC+1/(RC)^2
    num = 1/(R*C)^2;
    den = s^2+(2*s)/(R*C)+1/(R*C)^2;
    H = num/den;
    im2D_output = Clean_image_output(im1D, H);
end

%Active filter 2 (second order active highpass filter)
function [H,im2D_output] = Active_filter2(im1D) 
    % filter value
    s = tf('s'); % Define the Laplace variable 's'
    % Retrieve R and C values for the active filter
    [~,~,~,~,R,C] = filter_value();
    %num = s^2
    %den = s^2+2*s/RC+1/(RC)^2
    num = s^2;
    den = s^2+(2*s)/(R*C)+1/(R*C)^2;
    H = num/den;
    % Simulate the filter response to obtain the cleaned output signal
    im2D_output = Clean_image_output(im1D, H);
end