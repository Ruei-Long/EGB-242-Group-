%% EGB242 Assignment 2, Section 2 %%
% This file is a template for your MATLAB solution to Section 2.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;

% Begin writing your MATLAB solution below this line.

%% Section 2.1 -- Plotting impulse vs step response of DC motor system

% Time vector

t0      = 0; 
T       = 25;
samples = 1e4;
tv025   = timevec(t0, T, samples);
fs      = 1/samples; 
ts      = 1/fs; 

% Transfer function
Km      = 1;
alpha   = 0.5;
s       = tf('s');
H       = Km/(s*(s+alpha));

inputImpulse    = [1/ts, zeros(1, samples - 1)];
impulseResponse = lsim(H, inputImpulse, tv025);

inputStep       = ones(1, samples);
stepResponse    = lsim(H, inputStep, tv025);

figure;
subplot(2, 1, 1);
plot(tv025, impulseResponse);
title('Impulse response');
xlabel('Time [s]');
ylabel('Output [V]')

subplot(2, 1, 2);
plot(tv025, stepResponse);
title('Step response');
xlabel('Time [s]');
ylabel('Output [V]');

%% Functions

function t = timevec(t0, t0_plus_T, n)

t = linspace(t0, t0_plus_T, n + 1);
t = t(end - 1);

end
