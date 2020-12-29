/**
  Module name:  cen_generator_v1_0
  Author: P Trujillo (pablo@controlpaths.com)
  Date: Mar20
  Description: Clock enable generation according prescaler input.
  Revision: 1.0: Module created.
**/

module cen_generator_v1_0 (
  input clk,
  input rstn,

  input [31:0] i32_prescaler,
  output reg or_cen
);

  reg [31:0] r32_prescaler_counter;

  always @(posedge clk)
    if (!rstn) begin
      r32_prescaler_counter <= 32'd0;
      or_cen <= 1'b0;
    end
    else
      if (r32_prescaler_counter >= i32_prescaler) begin
        r32_prescaler_counter <= 32'd0;
        or_cen <= 1'b1;
      end
      else begin
        r32_prescaler_counter <= r32_prescaler_counter + 32'd1;
        or_cen <= 1'b0;
      end

endmodule
