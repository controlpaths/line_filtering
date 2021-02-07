% Automatically generated script to launch FPGA Data Capture App
% Instantiate FPGA Data Capture System object
if ~exist('fpgadc_obj','var') || ~isa(fpgadc_obj,'datacapture') || ~isprop(fpgadc_obj,'TimeStamp') || ~strcmpi(fpgadc_obj.TimeStamp,'31-Dec-2020 10:05:11')
    fpgadc_obj = datacapture;
end
fpgadc_obj.launchApp;
