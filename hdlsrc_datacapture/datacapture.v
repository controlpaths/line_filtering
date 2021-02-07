
/*-- ----------------------------------------------
-- File Name: datacapture.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/

module datacapture (
      clk,
      clk_enable,
      filter_input,
      filter_output,
      ready_to_capture
);


      input     clk;
      input     clk_enable;
      input    [13 : 0] filter_input;
      input    [17 : 0] filter_output;
      output    ready_to_capture;

  wire[39 : 0] all_data; // std40
  wire[7 : 0] pad_zero; // std8
  wire[95 : 0] trigger_setting; // std96
  wire trigger_1; // boolean
  wire start_flag; // boolean
  wire[74 : 0] trigger_setting_cond1; // std75
  wire[1 : 0] trigger_stage1; // std2
  wire[1 : 0] trigger_enable; // std2
  wire trigger_out1; // boolean
  wire[13 : 0] trigger_setting1; // std14
  wire[13 : 0] trigBitMask1; // std14
  wire[2 : 0] trigger_comparison_operator1; // std3
  wire trigger_signed1; // std1
  wire trigger_out2; // boolean
  wire[17 : 0] trigger_setting2; // std18
  wire[17 : 0] trigBitMask2; // std18
  wire[2 : 0] trigger_comparison_operator2; // std3
  wire trigger_signed2; // std1
  wire trigger_combine_rule; // boolean
hdlverifier_capture_core #(.DATA_WIDTH(40),.ADDR_WIDTH(10),.TRIG_WIDTH(96),.JTAG_ID(2)) u_hdlverifier_capture_core (
        .clk                  (clk),
        .clk_enable           (clk_enable),
        .start                (start_flag),
        .ready_to_capture     (ready_to_capture),
        .data                 (all_data),
        .trigger              (trigger_1),
        .trigger_setting      (trigger_setting)
);

hdlverifier_capture_trigger_condition u_hdlverifier_capture_trigger_condition (
        .clk                  (clk),
        .clk_enable           (clk_enable),
        .trigger              (trigger_1),
        .trigger_setting      (trigger_setting_cond1),
        .filter_input         (filter_input),
        .filter_output        (filter_output)
);

assign all_data = {pad_zero,filter_output,filter_input};
assign pad_zero = 0;assign trigger_setting_cond1 = trigger_setting[74 : 0];

endmodule
