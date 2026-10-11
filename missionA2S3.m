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
image_in_2D1 = received_site_image(imagesReceived, 1);
imwrite(image_in_2D1, 'image_in_2D1.png');

% this function use for make each image
function image = received_site_image(imagesReceived, image_in_1D_num)
    % pixel is top-to-bottom first, then left-to-right
    tall = 480;
    wide = 640;
    image_in_1D = imagesReceived(image_in_1D_num,:);
    image = reshape(image_in_1D, tall, wide);
    figure;
    imshow(image);
end

%% Section 3.2 time & frequency domain before filter
derty_time_domain_1 = Visualise_signal_time(imagesReceived,1);
saveas(gcf, 'derty_time_domain.png');
derty_freq_domain_1 = Visualise_signal_freq(imagesReceived,1);
saveas(gcf, 'derty_freq_domain.png');

% before filter time domain plot
function t = Visualise_signal_time(imagesReceived, image_in_1D_num)
    im1D = imagesReceived(image_in_1D_num,:);
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
function f = Visualise_signal_freq(imagesReceived, image_in_1D_num)
    im1D = imagesReceived(image_in_1D_num,:);
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

%% Section 3.3 - filter justification
%frequency response
[H_pass1, Pass1_2D_output] = Passive_filter1(imagesReceived, 1);
[H_pass2, Pass2_2D_output] = Passive_filter2(imagesReceived, 1);
[H_act1, Act1_2D_output] = Active_filter1(imagesReceived, 1);
[H_act2, Act2_2D_output] = Active_filter2(imagesReceived, 1); 
ltiview(H_pass1, H_pass2, H_act1, H_act2);

function im2D_output = Clean_image_output(imagesReceived, im1D_num, H)
    samples_frequency = 1000;
    im1D = imagesReceived(im1D_num,:);
    N = length(im1D);
    t = linspace(0, (N-1)/samples_frequency, N);
    im2D_output = lsim(H,im1D, t);
end

%Passive filter 1 (Band pass)
function [H, im2D_output] = Passive_filter1(imagesReceived, im1D_num) 
    % filter value
    s = tf('s');
    R1 = 1200;
    R2 = 1000;
    C1 = 10e-6;
    C2 = 4.7e-6;
    %num = sR1C1
    %den = s^2(R1R2C1C2)+s(R1C1+R2C2)+1
    num = R1*C1*s;
    den = s^2*(R1*R2*C1*C2)+s*(R1*C1+R2*C2)+1;
    H = num/den;
    im2D_output = Clean_image_output(imagesReceived, im1D_num, H);
end

%Passive filter 2 (lowpass filter)
function [H,im2D_output] = Passive_filter2(imagesReceived, im1D_num) 
    % filter value
    s = tf('s');
    R1 = 1200;
    R2 = 1000;
    C1 = 10e-6;
    C2 = 4.7e-6;
    %num = 1
    %den = s^2(R1R2C1C2)+s(R1C1+R1C2+R2C2)+1
    num = 1;
    den = s^2*(R1*R2*C1*C2)+s*(R1*C1+R1*C2+R2*C2)+1;
    H = num/den;
    im2D_output = Clean_image_output(imagesReceived, im1D_num, H);
end

%Active filter 1 (second order lowpass filter)
function [H,im2D_output] = Active_filter1(imagesReceived, im1D_num)
    % filter value
    s = tf('s');
    R = 820;
    C = 1e-6;
    %num = 1/(RC)^2
    %den = s^2+2*s/RC+1/(RC)^2
    num = 1/(R*C)^2;
    den = s^2+(2*s)/(R*C)+1/(R*C)^2;
    H = num/den;
    im2D_output = Clean_image_output(imagesReceived, im1D_num, H);
end

%Active filter 2 (second order highpass Butterworth filter)
function [H,im2D_output] = Active_filter2(imagesReceived, im1D_num) 
    % filter value
    s = tf('s');
    R = 820;
    C = 1e-6;
    %num = s^2
    %den = s^2+2*s/RC+1/(RC)^2
    num = s^2;
    den = s^2+(2*s)/(R*C)+1/(R*C)^2;
    H = num/den;
    im2D_output = Clean_image_output(imagesReceived, im1D_num, H);
end

%% Section 3.4 display clean image - time & frequency domain
[~, clean_image1] = Active_filter1(imagesReceived,1);
clean_image_1 = reshape(clean_image1, 480, 640);
figure;
imshow(clean_image_1);
imwrite(clean_image_1, 'clean_image_1.png');

clean_time_domain_1 = Visualise_signal_clean_time(clean_image1);
saveas(gcf, 'clean_time_domain.png');
clean_freq_domain_1 = Visualise_signal_clean_freq(clean_image1);
saveas(gcf, 'clean_freq_domain.png');

% after filter time domain plot
function t = Visualise_signal_clean_time(clean_image)
    N = length(clean_image);  % length of image
    samples_frequency = 1000; % pixel/sec
    t = linspace(0, (N-1)/samples_frequency, N);
    figure;
    plot(t, clean_image);
    xlabel("Time (s)");
    ylabel("Amplitude");
    title("Recived Signal in Time Domain");
    grid on;
end

% frequency domain
function f = Visualise_signal_clean_freq(clean_image)
    N = length(clean_image);  %length of image
    samples_frequency = 1000; %pixel/sec
    f = (-N/2 : N/2 - 1) * (samples_frequency / N); %Hz
    X = fft(clean_image);
    figure;
    plot(f, abs(fftshift(X))/N);
    xlabel("Frequency (Hz)");
    ylabel("Magnitude");
    title("Recived Signal in Frequency Domain");
    grid on;
end

%% Section 3.5 - filtering each image
image_in_2D2 = received_site_image(imagesReceived, 2);
imwrite(image_in_2D2, 'image_in_2D2.png');
image_in_2D3 = received_site_image(imagesReceived, 3);
imwrite(image_in_2D3, 'image_in_2D3.png');
image_in_2D4 = received_site_image(imagesReceived, 4);
imwrite(image_in_2D4, 'image_in_2D4.png');

% image 2
[~, clean_image2] = Active_filter1(imagesReceived,2);
clean_image_2 = reshape(clean_image2, 480, 640);
figure;
imshow(clean_image_2);
saveas(gcf, 'clean_image2.png');
% image 3
[~, clean_image3] = Active_filter1(imagesReceived,3);
clean_image_3 = reshape(clean_image3, 480, 640);
figure;
imshow(clean_image_3);
saveas(gcf, 'clean_image3.png');
% image 4
[~, clean_image4] = Active_filter1(imagesReceived,4);
clean_image_4 = reshape(clean_image4, 480, 640);
figure;
imshow(clean_image_4);
saveas(gcf, 'clean_image4.png');

