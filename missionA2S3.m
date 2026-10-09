%%%% EGB242 Assignment 2, Section 3 %%
% This file is a template for your MATLAB solution to Section 3.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 imagesReceived;

% Begin writing your MATLAB solution below this line.
% fddsv
%% Section 3.1
im2D1 = received_site_image(imagesReceived, 1);
im2D2 = received_site_image(imagesReceived, 2);
im2D3 = received_site_image(imagesReceived, 3);
im2D4 = received_site_image(imagesReceived, 4);
%imwrite(im2D, 'firstimage.png');

%%this function use for make each image
function image = received_site_image(imagesReceived, num_image)
    % pixel is top-to-bottom first, then left-to-right
    tall = 480;
    wide = 640;
    im1D = imagesReceived(num_image,:);
    image = reshape(im1D, tall, wide);
    figure;
    imshow(image);
end
%% Section 3.2
time_domain_1 = Visualise_signal_time(imagesReceived,1);
freq_domain_1 = Visualise_signal_freq(imagesReceived,1);

%time domain plot
function t = Visualise_signal_time(imagesReceived, im1D_num)
    im1D = imagesReceived(im1D_num,:);
    N = length(im1D); %length of image
    samples_frequency = 1000; %pixel/sec
    t = linspace(0, (N-1)/samples_frequency, N);
    figure;
    plot(t, im1D);
    xlabel("Time (s)");
    ylabel("Amplitude");
    title("Recived Signal in Time Domain");
    grid on;
end

%frequency domain
function f = Visualise_signal_freq(imagesReceived, im1D_num)
    im1D = imagesReceived(im1D_num,:);
    N = length(im1D); %length of image
    samples_frequency = 1000; %pixel/sec
    f = (-N/2 : N/2 - 1) * (samples_frequency / N); %Hz
    X = fft(im1D);
    
    figure;
    plot(f, abs(fftshift(X))/N);
    xlabel("Frequency (Hz)");
    ylabel("Magnitude");
    title("Recived Signal in Frequency Domain");
    grid on;
end
