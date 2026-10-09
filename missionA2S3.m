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
