%% EGB242 Assignment 2, Section 2 %%
% This file is a template for your MATLAB solution to Section 2.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;

% Begin writing your MATLAB solution below this line.

%% Section 2.1 -- Plotting impulse vs step response of DC motor system

% Declaration of s as a tf variable.
s = tf('s');

% Time vector
t0      = 0;    % initial t: 0s
T       = 25;   % final t:   25s
samples = 1e4;  
tv025   = linspace(t0, T, samples); % Time vector from 0-25s, 10k samples

% Hand-evaluation of step response found time domain function to be:
% (-4 + 2t + 4e^{-0.5t})u(t) 
% Because our time vector is only valid for t >= 0, we do not need to
% multiply by the heaviside function in this case. Therefore;

OL_stepResponse = (-4 + 2*tv025 + 4*exp(-0.5*tv025));

figure()
plot(tv025, OL_stepResponse);
hold on
title('Step Input vs Step Response')
plot(tv025, heaviside(tv025));
legend('Step Input', 'Step Response')
xlabel('Time (s)')
ylabel('\psi (t)')
hold off

% ltiview 

OL_stepResponse_LTI = tf(1,[1 0.5 0]);

ltiview(OL_stepResponse_LTI);

%% Section 2.3 

% Defining the numerator and denominator of the transfer function
num = 1;
den = [1, 0.5, 1];

% Assigning these to a transfer function object
H = tf(num, den);

% Creating the input step for use within lsim
inputStep = ones(1, samples);
CL_stepResponse = lsim(H, inputStep, tv025);

% Plotting
figure()
plot(tv025, heaviside(tv025),  'LineWidth', 2, 'Color', ...
    [0.8500, 0.3250, 0.0980])
hold on
plot(tv025, CL_stepResponse, 'Color', [0, 0.4470, 0.7410])
title('Step Response of the Closed-Loop System')
legend('Step Response', 'Step Input')
xlabel('Time (s)')
ylabel('\psi(t) (rad)')
hAxes = findobj(gcf,"Type","axes");
hAxes.FontSize = 16;
hold off

% LTIview for pole-zero plot

ltiview(H, OL_stepResponse_LTI)

%% Section 2.4 - Peak (Tp), Settling (Ts) time, percent overshoot (pcOS)

stepinfo(H)

%% Section 2.5 - Investigating effects of gain blocks

gains   = [0.1, 0.2, 0.5, 1, 2];    % array of gain values
Kfwd    = cell(1, 5); % using cells to store tf objects
Kfb     = cell(1, 5);
simKfb  = cell(1, 5); % using cells to store the vectors also
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
xlabel('Time (s)')
ylabel('\psi(t) (rad)')
ylim([0, 12])
hold on;

for n = 1:5
    plot(tv025, simKfb{n}, 'LineWidth', 2)
end

legend('K_{fb} = 0.1', 'K_{fb} = 0.2', 'K_{fb} = 0.5', ... 
       'K_{fb} = 1', 'K_{fb} = 2', 'Orientation', 'horizontal') 
hold off;

subplot(2,1,2);
title('Effect of K_{fwd} on Step Response')
xlabel('Time (s)')
ylabel('\psi(t) (rad)')
ylim([0, 2])
hold on;
for n = 1:5
    plot(tv025, simKfwd{n}, 'LineWidth', 2)
end

legend('K_{fwd} = 0.1', 'K_{fwd} = 0.2', 'K_{fwd} = 0.5', ... 
       'K_{fwd} = 1', 'K_{fwd} = 2', 'Orientation', 'horizontal')
hAxes = findobj(gcf,"Type","axes");
hAxes(2).Box = "on";
hAxes(1).Box = "on";
hold off;

%% Section 2.6 - Selecting Gain Values

% Peak time defined by colleague as Tp = 14
% Initialising Tp
Tp = 0; 
% Brute-Force while loop, numerical evaluation.
resolution = 2e4;
t = linspace(0, T, resolution);
inputStepR = ones(1, resolution);

% A constant to ensure the counter starts at 25 (not wasting cycles)
counter = 0.078292 * resolution; 

% This while loop will find the first value of Tp that is approximately
% equal to 14. Given fb is set to 1, and return the value of Kfwd.
while isapprox(Tp, 14, 'veryloose' ) ~= 1
    
    counter_descale = counter/resolution;
    
    [testTF, testTFsim] = tfeval(counter_descale, 1, t, inputStepR);
    Tp = stepinfo(testTFsim, t).PeakTime;

    counter = counter + 1;
   
end
Kfwd_Tp14 = counter_descale;
disp(Kfwd_Tp14)

ltiview(testTF);
stepinfo(testTF);

% Setting Kfb to 1, we find the value to achieve ~14s Tp is approx 0.1128
% This gain product may now be used to find the value of Kfwd for our 
% intended final value.

% Given that final value = 1/Kfb. We can plug any value of Kfb into this
% and multiply by 0.1128 and we will have a step response with a Peak-Time
% approximately equal to 14s. 

% Therefore (given this is an underdamped case and the math is valid),
% we elect to use the calculated value, rather than the numerical above.



ltiview(cameraTF);
stepinfo(cameraTF)



%% Setting Specified Gain Factor and transfer function

gain_factor = (0.5^2)/4 + pi^2/(14^2);
Kfb_scalar = 2*pi;

cameraTF = tfeval(gain_factor*Kfb_scalar, 1/Kfb_scalar, tv025, inputStep);
ltiview(cameraTF);
stepinfo(cameraTF)
Tp = stepinfo(cameraTF).PeakTime;

%% Section 2.7

startVoltage = 1/12;
endVoltage   = 7/12;     

[startIm, finalIm] = cameraPan(startVoltage, endVoltage, cameraTF);

%% Showing the first image

imshow(startIm);

%% Showing the final image

imshow(finalIm);
%% Function Definitions

% This function helps to evaluate the adjustable gains of the transfer
% function. 

function [Psi, sim] = tfeval(Kfwd, Kfb, timeVector, input)

num = Kfwd;
den = [1, 0.5, Kfwd*Kfb];
Psi = tf(num, den);
sim = lsim(Psi, input, timeVector);

end