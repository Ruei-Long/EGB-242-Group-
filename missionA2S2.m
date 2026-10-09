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

figure()
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

figure()
plot(tv025, CL_stepResponse);

%% Section 2.4 - Peak (Tp), Settling (Ts) time, percent overshoot (pcOS)

[omegan, zeta, Tp, Ts, pcOS] = transientSpecs(0.5, 1);


% stepinfo(H)
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

[cameraTF, cameraTFsim] = tfeval(0.1, 1, tv025, inputStep);

figure()
plot(tv025, cameraTFsim);

[omeganctf, zetactf, Tpctf, Tsctf, pcOSctf] = transientSpecs(0.5, 0.1);



%% Function Definitions

function [Psi, sim] = tfeval(Kfwd, Kfb, timeVector, input)

num = Kfwd;
den = [1, 0.5, Kfwd*Kfb];
Psi = tf(num, den);
sim = lsim(Psi, input, timeVector);

end

function [omegan, zeta, Tp, Ts, pcOS] = transientSpecs(a, b)

omegan  = sqrt(b);          % natural frequency (rad/s)
zeta    = a / (2*omegan);   % damping ratio
Tp   = pi / (omegan*(sqrt(1 - zeta^2)));        % peak time
Ts   = 4 / (zeta*omegan);                       % settling time
pcOS = exp(-(zeta*pi)/(sqrt(1-zeta^2)))*100;    % percent overshoot

end
