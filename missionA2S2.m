%% EGB242 Assignment 2, Section 2 %%
% This file is a template for your MATLAB solution to Section 2.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;

% Begin writing your MATLAB solution below this line.

%% Section 2.1 -- Plotting impulse vs step response of DC motor system
s = tf('s');

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

figure()
plot(tv025, OL_stepResponse);
hold on
title('Step Input vs Step Response')
plot(tv025, heaviside(tv025), 'LineWidth', 2);
legend('Step Response', 'Step Input')
xlabel('Time (s)')
ylabel('\psi (t) (rad)')
ylim([0, 20])
hold off

%% Section 2.3 

num = 1;
den = [1, 0.5, 1];
H = tf(num, den);

inputStep = ones(1, samples);
CL_stepResponse = lsim(H, inputStep, tv025);

figure()
plot(tv025, CL_stepResponse);


%% Verifying Hand-working in MATLAB

num_v = 1;
den_v = [1, 0.5, 0];
OL_stepResponse_tf = tf(num_v, den_v);

OL_stepResponse_v = lsim(OL_stepResponse_tf, inputStep, tv025);
figure()
plot(tv025, OL_stepResponse_v);

%% Section 2.4 - Peak (Tp), Settling (Ts) time, percent overshoot (pcOS)

stepinfo(H)

%% Section 2.5 - Investigating effects of gain blocks

gains   = [0.1, 0.2, 0.5, 1, 2];    % array of gain values
Kfwd    = cell(1, 5); % cell needed as normal arrays cant store tf objects
Kfb     = cell(1, 5);
simKfb  = cell(1, 5); % cell needed to store each vector in an array
simKfwd = cell(1, 5);

for n = 1:5 % for each entry in gains, execute the following
    % Evaluating transfer functions
    [Kfb{n}, simKfb{n}]  = ... 
        tfeval(1, gains(n), tv025, inputStep);  % sweeping Kfb 
    [Kfwd{n}, simKfwd{n}]= ... 
        tfeval(gains(n), 1, tv025, inputStep);  % sweeping Kfwd
end    

figure()
subplot(2,1,1);
title('Effect of K_{fb} on Step Response')
hold on;

for n = 1:5
    plot(tv025, simKfb{n})
end

legend('K_{fb} = 0.1', 'K_{fb} = 0.2', 'K_{fb} = 0.5', ... 
       'K_{fb} = 1', 'K_{fb} = 2') 
hold off;

subplot(2,1,2);
title('Effect of K_{fwd} on Step Response')
hold on;
for n = 1:5
    plot(tv025, simKfwd{n})
end

legend('K_{fwd} = 0.1', 'K_{fwd} = 0.2', 'K_{fwd} = 0.5', ... 
       'K_{fwd} = 1', 'K_{fwd} = 2')
hold off;

%% Section 2.6 - Selecting Gain Values

% Peak time defined by colleague as Tp = 14




%stepinfo(cameraTF);

% This while loop will find the first value of Tp that is approximately
% equal to 14. Given fb is set to 1.

counter = 1;

% Initialising 'testTF' to the critically damped case
[testTF, testTFsim] = tfeval(0.625, 2*pi, tv025, inputStep);

% Initialising Tp 
Tp = stepinfo(testTF).PeakTime;

% Brute-Force while loop, numerical evaluation.

resolution = 2e4;
t = linspace(0, T, resolution);
inputStepR = ones(1, resolution);

% A constant to ensure the counter starts at 25 (not wasting cycles)
counter = 0.078292 * resolution; 

while isapprox(Tp, 14, 'veryloose' ) ~= 1
    
    
    counter_descale = counter/resolution;
    
    [testTF, testTFsim] = tfeval(counter_descale, 1, t, inputStepR);
    Tp = stepinfo(testTFsim, t).PeakTime;

    counter = counter + 1;

end

disp(counter_descale)

% Setting Kfb to 1, we find the value to achieve ~14s Tp is approx 0.1128
% This scaling factor may now be used to find the value of Kfwd for our 
% intended final value.

% Given that, final value = 1/Kfb. We can plug any value of Kfb into this
% and multiply by 0.1128 and we will have a step response with a Peak-Time
% approximately equal to 14s. 

% Therefore (given this is an underdamped case and the math is valid),
% we elect to use the calculated value, rather than the numerical above.

Kfwd_const = 1*((0.5^2)/4 + pi^2/(14^2));

ltiview(testTF);
stepinfo(testTF)

%%
Kfb_scalar = 2*pi;

test = tfeval(Kfwd_const*Kfb_scalar, 1/Kfb_scalar, tv025, inputStep);
ltiview(test);
stepinfo(test)
Tp = stepinfo(test).PeakTime;

%% Section 2.7

startVoltage = 1/12;
endVoltage   = 7/12;     

[startIm, finalIm] = cameraPan(startVoltage, endVoltage, test);


%% Function Definitions

function [Psi, sim] = tfeval(Kfwd, Kfb, timeVector, input)

num = Kfwd;
den = [1, 0.5, Kfwd*Kfb];
Psi = tf(num, den);
sim = lsim(Psi, input, timeVector);

end