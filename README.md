# Line filtering project.
Example project that shows how to decode a signal from a line where 3 channels are transmitted simultaneously. The project contains the next files.
- **signal_generation.m** Script to generate the 3 channels line signal.  
- **filter_from_wks.m** Script to test the filter on MATLAB workspace.  
- **filter_from_simulink.m** Script to test the filter on a quantized model on Simulink.
- **read_ila_data.m** Script to plot ila data from the project implementation on Eclypse Z7.
- **ila_data.csv** ILA data extracted from the project implemenation on Eclypse Z7. Input signal is white noise.
- **butter_test.slx** Simulink model to test quantized the filter.
- **butter_test_scope.slx** Simulink model to test the filter with a scope and a white noise generator. Used to generate the HDL.
- **butter_fil.slx** Simulink model to test the filter with FPGA-in-the-Loop.  

Folders **/hdlsrc** and **/hdlsrc2** contains the generated HDL files.
Folder **/hdlsrc_datacapture** contains FPGA Data Capture module.
