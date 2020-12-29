
################################################################
# This is a generated script based on design: fircomp_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source fircomp_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# butterbp, cen_generator_v1_0

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART digilentinc.com:eclypse-z7:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name fircomp_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
user.org:user:AXI_Stream_ZMOD_ADC:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
butterbp\
cen_generator_v1_0\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk125mhz [ create_bd_port -dir I -type clk -freq_hz 125000000 clk125mhz ]
  set_property -dict [ list \
   CONFIG.PHASE {0.000} \
 ] $clk125mhz
  set i14_adc_data [ create_bd_port -dir I -from 13 -to 0 i14_adc_data ]
  set i_adc_dco [ create_bd_port -dir I -type clk -freq_hz 100000000 i_adc_dco ]
  set o_adc_clkout_n [ create_bd_port -dir O o_adc_clkout_n ]
  set o_adc_clkout_p [ create_bd_port -dir O o_adc_clkout_p ]
  set o_adc_cs [ create_bd_port -dir O o_adc_cs ]
  set o_adc_sck [ create_bd_port -dir O o_adc_sck ]
  set o_adc_sdio [ create_bd_port -dir O o_adc_sdio ]
  set o_adc_sync [ create_bd_port -dir O o_adc_sync ]
  set o_zmod_adc_com_h [ create_bd_port -dir O o_zmod_adc_com_h ]
  set o_zmod_adc_com_l [ create_bd_port -dir O o_zmod_adc_com_l ]
  set o_zmod_adc_coupling_h_a [ create_bd_port -dir O o_zmod_adc_coupling_h_a ]
  set o_zmod_adc_coupling_h_b [ create_bd_port -dir O o_zmod_adc_coupling_h_b ]
  set o_zmod_adc_coupling_l_a [ create_bd_port -dir O o_zmod_adc_coupling_l_a ]
  set o_zmod_adc_coupling_l_b [ create_bd_port -dir O o_zmod_adc_coupling_l_b ]
  set o_zmod_adc_gain_h_a [ create_bd_port -dir O o_zmod_adc_gain_h_a ]
  set o_zmod_adc_gain_h_b [ create_bd_port -dir O o_zmod_adc_gain_h_b ]
  set o_zmod_adc_gain_l_a [ create_bd_port -dir O o_zmod_adc_gain_l_a ]
  set o_zmod_adc_gain_l_b [ create_bd_port -dir O o_zmod_adc_gain_l_b ]

  # Create instance: AXI_Stream_ZMOD_ADC_0, and set properties
  set AXI_Stream_ZMOD_ADC_0 [ create_bd_cell -type ip -vlnv user.org:user:AXI_Stream_ZMOD_ADC:1.0 AXI_Stream_ZMOD_ADC_0 ]

  # Create instance: butterbp_0, and set properties
  set block_name butterbp
  set block_cell_name butterbp_0
  if { [catch {set butterbp_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $butterbp_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: cen_generator_v1_0_0, and set properties
  set block_name cen_generator_v1_0
  set block_cell_name cen_generator_v1_0_0
  if { [catch {set cen_generator_v1_0_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $cen_generator_v1_0_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {4} \
   CONFIG.C_DATA_DEPTH {65536} \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_OF_PROBES {2} \
   CONFIG.C_PROBE0_TYPE {0} \
 ] $system_ila_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {9} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_2

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create port connections
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_adc_clkout_n [get_bd_ports o_adc_clkout_n] [get_bd_pins AXI_Stream_ZMOD_ADC_0/adc_clkout_n]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_adc_clkout_p [get_bd_ports o_adc_clkout_p] [get_bd_pins AXI_Stream_ZMOD_ADC_0/adc_clkout_p]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_cs [get_bd_ports o_adc_cs] [get_bd_pins AXI_Stream_ZMOD_ADC_0/cs]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_m00_axis_tdata [get_bd_pins AXI_Stream_ZMOD_ADC_0/m00_axis_tdata] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_o_adc_sync [get_bd_ports o_adc_sync] [get_bd_pins AXI_Stream_ZMOD_ADC_0/o_adc_sync]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_sck [get_bd_ports o_adc_sck] [get_bd_pins AXI_Stream_ZMOD_ADC_0/sck]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_sdio [get_bd_ports o_adc_sdio] [get_bd_pins AXI_Stream_ZMOD_ADC_0/sdio]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_com_h [get_bd_ports o_zmod_adc_com_h] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_com_h]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_com_l [get_bd_ports o_zmod_adc_com_l] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_com_l]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_coupling_h_a [get_bd_ports o_zmod_adc_coupling_h_a] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_coupling_h_a]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_coupling_h_b [get_bd_ports o_zmod_adc_coupling_h_b] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_coupling_h_b]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_coupling_l_a [get_bd_ports o_zmod_adc_coupling_l_a] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_coupling_l_a]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_coupling_l_b [get_bd_ports o_zmod_adc_coupling_l_b] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_coupling_l_b]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_gain_h_a [get_bd_ports o_zmod_adc_gain_h_a] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_gain_h_a]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_gain_h_b [get_bd_ports o_zmod_adc_gain_h_b] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_gain_h_b]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_gain_l_a [get_bd_ports o_zmod_adc_gain_l_a] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_gain_l_a]
  connect_bd_net -net AXI_Stream_ZMOD_ADC_0_zmod_adc_gain_l_b [get_bd_ports o_zmod_adc_gain_l_b] [get_bd_pins AXI_Stream_ZMOD_ADC_0/zmod_adc_gain_l_b]
  connect_bd_net -net butterbp_0_Out [get_bd_pins butterbp_0/Out] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net cen_generator_v1_0_0_or_cen [get_bd_pins butterbp_0/clk_enable] [get_bd_pins cen_generator_v1_0_0/or_cen]
  connect_bd_net -net clk125mhz_1 [get_bd_ports clk125mhz] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins AXI_Stream_ZMOD_ADC_0/adc_clk] [get_bd_pins AXI_Stream_ZMOD_ADC_0/clk_spi] [get_bd_pins AXI_Stream_ZMOD_ADC_0/m00_axis_aclk] [get_bd_pins butterbp_0/clk] [get_bd_pins cen_generator_v1_0_0/clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins AXI_Stream_ZMOD_ADC_0/m00_axis_aresetn] [get_bd_pins cen_generator_v1_0_0/rstn] [get_bd_pins clk_wiz_0/locked] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net i14_adc_data_1 [get_bd_ports i14_adc_data] [get_bd_pins AXI_Stream_ZMOD_ADC_0/adc_ddr_data]
  connect_bd_net -net i_adc_dco_1 [get_bd_ports i_adc_dco] [get_bd_pins AXI_Stream_ZMOD_ADC_0/adc_ddr_clk]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins butterbp_0/reset] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins clk_wiz_0/reset] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins cen_generator_v1_0_0/i32_prescaler] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins butterbp_0/In] [get_bd_pins system_ila_0/probe1] [get_bd_pins xlslice_0/Dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


