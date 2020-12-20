% Filter signal from workspace

clear all
close all
clc

load('butterbd_fda.mat')
load('signal_line.mat')

signalFilt = filter(Hd, signal);
signalFiltDft = abs(fft(signalFilt))*2/length(signalFilt);
fVector = linspace(0,fs,length(t));

figure
plot(fVector, signalDft, 'r')
hold on
plot(fVector, signalFiltDft, 'b')
title('Line signal Filtered')
xlim([800e3, 1200e3])
hold off
legend('Line signal', 'Filtered signal')