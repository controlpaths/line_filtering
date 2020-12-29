## This file is a general .xdc for the Eclypse Z7 Rev. B.0
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## 125MHz Clock from Ethernet PHY
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports clk125mhz]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk125mhz]

## RGB LEDs
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {or3_led0[0]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {or3_led0[1]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports {or3_led0[2]}]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {or3_led1[0]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {or3_led1[1]}]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {or3_led1[2]}]

## Syzygy Port A
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS18} [get_ports o_dac_clkout]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS18} [get_ports o_dac_fsadjq]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS18} [get_ports o_dac_fsadji]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[12]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[13]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS18} [get_ports o_dac_sck]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS18} [get_ports o_dac_rst]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[10]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[11]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS18} [get_ports o_dac_cs]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS18} [get_ports o_dac_sdio]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[8]}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[9]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports or_zmod_dac_relay]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[6]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[7]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS18} [get_ports o_dac_dclkio]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[4]}]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[5]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[1]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[0]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[3]}]

## Syzygy Port B
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD DIFF_HSTL_I_18} [get_ports o_adc_clkout_n]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD DIFF_HSTL_I_18} [get_ports o_adc_clkout_p]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_coupling_l_a]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_coupling_h_a]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_coupling_l_b]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_coupling_h_b]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18} [get_ports o_adc_sck]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS18} [get_ports o_adc_sdio]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_gain_l_b]
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_gain_h_b]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[2]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[9]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_gain_l_a]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_gain_h_a]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[4]}]
set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[3]}]
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_com_l]
set_property -dict {PACKAGE_PIN Y20 IOSTANDARD LVCMOS18} [get_ports o_zmod_adc_com_h]
#set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS18} [get_ports { }]; #IO_L13N_T2_MRCC Sch=syzygy_b_p2c_clk_n
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS18} [get_ports i_adc_dco]
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[5]}]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[8]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[6]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[10]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[7]}]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[11]}]
set_property -dict {PACKAGE_PIN AB19 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[1]}]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[12]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[0]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS18} [get_ports {i14_adc_data[13]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18} [get_ports o_adc_cs]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS18} [get_ports o_adc_sync]

### Pmod Header JA
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports i_rx]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports o_tx]
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { o_ja[2] }]; #IO_L1N_T0_AD0N Sch=ja3_fpga
#set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { o_ja[3] }]; #IO_L1P_T0_AD0P Sch=ja4_fpga
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { o_ja[4] }]; #IO_L2N_T0_AD8N Sch=ja7_fpga
#set_property -dict { PACKAGE_PIN D16   IOSTANDARD LVCMOS33 } [get_ports { o_ja[5] }]; #IO_L2P_T0_AD8P Sch=ja8_fpga
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { o_ja[6] }]; #IO_L3N_T0_DQS_AD1N Sch=ja9_fpga
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { o_ja[7] }]; #IO_L3P_T0_DQS_AD1P Sch=ja10_fpga
