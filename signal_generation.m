% Signal generation Script

clear all
close all
clc

fs = 10e6;
tmax = 0.01;
t = [0:1/fs:tmax];

fNyq = fs/2;

signal = (rand(1,length(t))-0.5)*10;

plot(signal)

signalDft = abs(fft(signal))*2/length(signal);
fVector = linspace(0,fs,length(t));
figure
plot(fVector, signalDft)

% Channel 0 data
[b,a] = butter(4,[890e3/fNyq 910e3/fNyq]);
signal0 = filter(b,a, signal);

% Channel 1 data
[b,a] = butter(4,[990e3/fNyq 1010e3/fNyq]);
signal1 = filter(b,a, signal);

% Channel 2 data
[b,a] = butter(4,[1090e3/fNyq 1110e3/fNyq]);
signal2 = filter(b,a, signal);

signal = signal0+signal1+signal2;
signalDft = abs(fft(signal))*2/length(signal);

figure
plot(fVector, signalDft)
title('Line signal')
xlim([800e3, 1200e3])

save("signal_line.mat", 'signal', 'signalDft', 'fs', 'tmax', 't')



