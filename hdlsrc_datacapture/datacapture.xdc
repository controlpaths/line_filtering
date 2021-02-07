# Automatically generated constaint file for FPGA Data Capture IP
# Add this file to your Vivado project
create_clock -period 30.000 -name tck -waveform {0.000 15.000} [get_nets -of_object [get_cells -hierarchical -filter {REF_NAME =~ hdlverifier_capture_jtag_core}] -filter {NAME =~ */tck}]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_cells -hierarchical -filter { NAME =~ "*reg_full*" && ( PRIMITIVE_TYPE =~ FLOP_LATCH.flop.*   || PRIMITIVE_TYPE == RTL_REGISTER.flop.RTL_REG || PRIMITIVE_TYPE =~ REGISTER.SDR.*  ) }]] -group [get_clocks -of_objects [get_cells -hierarchical -filter { NAME =~ "*data_reg*" && ( PRIMITIVE_TYPE =~ FLOP_LATCH.flop.*   || PRIMITIVE_TYPE == RTL_REGISTER.flop.RTL_REG || PRIMITIVE_TYPE =~ REGISTER.SDR.*  ) }] ]
