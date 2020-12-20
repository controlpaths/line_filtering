
% Filter simulation
clear all
close all
clc

fs = 100e6;

ila_data = readtable("ila_data.csv");

output_data = ila_data.fircomp_bd_i_system_ila_0_inst_probe0_1_17_0_;
input_data = ila_data.fircomp_bd_i_system_ila_0_inst_probe1_1_13_0_;
fVector = linspace(0,fs,length(input_data));

inputDft = abs(fft(input_data));
outputDft = abs(fft(output_data));

plot(fVector, inputDft)
hold on
plot(fVector, outputDft);
hold off
legend("Input", "Output");
xlim([800e3 1200e3])