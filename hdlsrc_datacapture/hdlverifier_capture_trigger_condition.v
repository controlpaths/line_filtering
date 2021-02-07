
/*-- ----------------------------------------------
-- File Name: hdlverifier_capture_trigger_condition.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/

module hdlverifier_capture_trigger_condition (
      clk,
      clk_enable,
      trigger_setting,
      filter_input,
      filter_output,
      trigger
);


      input     clk;
      input     clk_enable;
      input    [74 : 0] trigger_setting;
      input    [13 : 0] filter_input;
      input    [17 : 0] filter_output;
      output    trigger;

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
hdlverifier_capture_comparator #(.WIDTH(14)) u_hdlverifier_capture_comparator (
        .clk                  (clk),
        .clk_enable           (clk_enable),
        .data                 (filter_input),
        .trigger              (trigger_out1),
        .trigger_setting      (trigger_setting1),
        .trigger_bitmask      (trigBitMask1),
        .trigger_comparison_operator (trigger_comparison_operator1),
        .trigger_signed       (trigger_signed1)
);

hdlverifier_capture_comparator #(.WIDTH(18)) u_hdlverifier_capture_comparator_inst1 (
        .clk                  (clk),
        .clk_enable           (clk_enable),
        .data                 (filter_output),
        .trigger              (trigger_out2),
        .trigger_setting      (trigger_setting2),
        .trigger_bitmask      (trigBitMask2),
        .trigger_comparison_operator (trigger_comparison_operator2),
        .trigger_signed       (trigger_signed2)
);

hdlverifier_capture_trigger_combine #(.WIDTH(2)) u_hdlverifier_capture_trigger_combine (
        .clk                  (clk),
        .clk_enable           (clk_enable),
        .trigger_in           (trigger_stage1),
        .trigger_enable       (trigger_enable),
        .trigger_out          (trigger),
        .trigger_combination_rule (trigger_combine_rule)
);

assign trigger_stage1 = {trigger_out1,trigger_out2};
assign trigger_enable = trigger_setting[73 : 72];
assign trigger_setting1 = trigger_setting[13 : 0];
assign trigBitMask1 = trigger_setting[27 : 14];
assign trigger_comparison_operator1 = trigger_setting[30 : 28];
assign trigger_signed1 = trigger_setting[31];
assign trigger_setting2 = trigger_setting[49 : 32];
assign trigBitMask2 = trigger_setting[67 : 50];
assign trigger_comparison_operator2 = trigger_setting[70 : 68];
assign trigger_signed2 = trigger_setting[71];
assign trigger_combine_rule = trigger_setting[74];

endmodule
