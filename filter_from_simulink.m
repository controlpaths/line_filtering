% Simulink model to test quantize.

clear all
close all
clc

load('signal_line.mat')

out = sim('butter_test', tmax)
fVectorSimulink = linspace(0,fs,length(out.simout1(2,:)));
figure
plot(fVectorSimulink, abs(fft(out.simout1(2,:))), 'r')
hold on
plot(fVectorSimulink, abs(fft(out.simout(2,:))), 'b')
title('Simulink filter model')
xlim([800e3, 1200e3])
hold off
legend('Line signal', 'Filtered signal')