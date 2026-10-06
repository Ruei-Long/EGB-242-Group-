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
tv025   = linspace(t0, T, samples);
fs      = 1/samples; 
ts      = 1/fs; 

% Hand-evaluation of step response found time domain function to be:
% (-4 + 2t + 4e^{-0.5t})u(t) 
% Because our time vector is only valid for t >= 0, we do not need to
% multiply by the heaviside function in this case. Therefore;

OL_stepResponse = (-4 + 2*tv025 + 4*exp(-0.5*tv025));

figure(1)
plot(tv025, OL_stepResponse);
hold on
title('Step Input vs Step Response')
plot(tv025, heaviside(tv025));
legend('Step Input', 'Step Response')
xlabel('Time (s)')
ylabel('\psi (t)')
hold off

%% Section 2.3 
s = tf('s');
num = 1;
den = [1, 0.5, 1];
H = tf(num, den);

inputStep = ones(1, samples);
CL_stepResponse = lsim(H, inputStep, tv025);

figure(2)
plot(tv025, CL_stepResponse);

ltiview(H);