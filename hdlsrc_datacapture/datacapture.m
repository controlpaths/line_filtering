% datacapture is a generated class used for FPGA Data Capture. datacapture
% connects MATLAB with a FPGA and captures the FPGA internal signals via
% JTAG connection.
% 
% dco = datacapture returns a FPGA Data Capture System object generated by 
% the user. It captures internal signals from an FPGA that contains the FPGA 
% Data Capture HDL IP core, and returns the data to MATLAB over the JTAG cable. 
% 
%  Step method syntax
% [Capture_Window,Trigger_Position,filter_input,filter_output]=step(dco) connects to the FPGA, and read data from the FPGA.
% 
% datacapture methods:
% step - see above description for use of this method
% release - Allow property value and input characteristics changes, and release connection to FPGA board
% clone - Create datacapture object with same property values
% isLocked - Locked status (logical)
% setNumberofTriggerStages   - Set number of trigger stages
% setTriggerCondition - Set trigger condition for each trigger signal
% setTriggerCombinationOperator - Set trigger combination operator
% setTriggerComparisonOperator - Set trigger comparison operator
% setTriggerTimeout     - Set timeout for each stage
% setDataType - Set signal data type
% displayDataTypes - Display current data type settings
% displayTriggerCondition - Display current trigger condition
% launchApp - Launch Graphical User Interface (GUI) App for setting data types, triggers, and capture data interactively
% 
% datacapture properties:
% TimeOut - Time to wait before throwing exception, if trigger condition is not met
% TriggerPosition - The number of samples captured before trigger event
% JTAGCableName - Name of the JTAG cable used for data capture
% JTAGChainPosition - JTAG chain position number of the target FPGA
% IRLengthBefore  - Instruction register lengths before FPGA
% IRLengthAfter   - Instruction register lengths after FPGA
% TckFrequency    - JTAG clock frequency in MHz. 
%
% Created: 31-Dec-2020 10:05:11
% Generated by MATLAB 9.9 and HDL Verifier 6.2

classdef datacapture< hdlverifier.FPGADataReader

methods
    function obj = datacapture
        obj.TriggerPosition  =  0;
        obj.NumCaptureWindows  =  1;
        obj.TimeOut          = 10;
        obj.MaxNumTriggerStages  = 1;
        obj.NumTriggerStages  = 1;
        obj.setDataType('Capture_Window','uint32');
        obj.setDataType('Trigger_Position','boolean');
        obj.setDataType('filter_input',numerictype(0,14,0));
        obj.setDataType('filter_output',numerictype(0,18,0));
        setTriggerConditionArray(obj)
    end
end

% !!! Do NOT change any of the constant properties below !!!
properties (Nontunable, Constant)
    % SamplesPerFrame Samples per frame
    SamplesPerFrame = 1024
    BitWidth = [32   1  14  18]
    SignalNames = {'Capture_Window','Trigger_Position','filter_input','filter_output'}
    IsSignalTrigger = [0  0  1  1]
    IsSignalData = [0  0  1  1]
    IsMetaData = [1  1  0  0]
    % FPGAVendor FPGA vendor
    FPGAVendor = 'Xilinx'
    % Version
    Version = '1.0'
    % Timestamp
    TimeStamp = '31-Dec-2020 10:05:11'
end

end
