
/*-- ----------------------------------------------
-- File Name: hdlverifier_capture_comparator.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/


module hdlverifier_capture_comparator #(parameter WIDTH = 8) (
    input clk,
    input clk_enable,
    input [WIDTH-1:0] data,
    input [WIDTH-1:0] trigger_setting,
    input [WIDTH-1:0] trigger_bitmask,
    input [2:0] trigger_comparison_operator,
    input trigger_signed,
    output reg trigger);

    reg [WIDTH-1:0] trigger_mask_stage1;
    reg [WIDTH-1:0] trigger_mask_stage2; 

    always @ (*) begin
      trigger_mask_stage1 = (data) ~^ (trigger_setting);
    end

    always @ (*) begin
      trigger_mask_stage2 = (trigger_mask_stage1) | (trigger_bitmask);
    end

    
    always@(posedge clk) begin
      if(clk_enable) begin
	  case ({trigger_signed, trigger_comparison_operator})
	4'b0000: trigger <=  (&trigger_mask_stage2);
        4'b0001: trigger <=  ((&trigger_mask_stage2) == 1'd0);
        4'b0010: trigger <=  (data <  trigger_setting);
        4'b0011: trigger <=  (data >  trigger_setting);
        4'b0100: trigger <=  (data <= trigger_setting);
        4'b0101: trigger <=  (data >= trigger_setting);
	4'b1000: trigger <=  (&trigger_mask_stage2);
        4'b1001: trigger <=  ((&trigger_mask_stage2) == 1'd0);
        4'b1010: trigger <=  ($signed(data) <  $signed(trigger_setting));
        4'b1011: trigger <=  ($signed(data) >  $signed(trigger_setting));
        4'b1100: trigger <=  ($signed(data) <= $signed(trigger_setting));
        4'b1101: trigger <=  ($signed(data) >= $signed(trigger_setting));
	    default:trigger <=  1'd0;
      endcase
	  end
    end
    
endmodule