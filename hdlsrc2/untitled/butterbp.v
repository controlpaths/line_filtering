// -------------------------------------------------------------
// 
// File Name: hdlsrc2/untitled/butterbp.v
// Created: 2020-12-08 10:07:10
// 
// Generated by MATLAB 9.9 and HDL Coder 3.17
// 
// 
// -- -------------------------------------------------------------
// -- Rate and Clocking Details
// -- -------------------------------------------------------------
// Model base rate: 0.0125
// Target subsystem base rate: 0.0125
// 
// 
// Clock Enable  Sample Time
// -- -------------------------------------------------------------
// ce_out        0.1
// -- -------------------------------------------------------------
// 
// 
// Output Signal                 Clock Enable  Sample Time
// -- -------------------------------------------------------------
// Out                           ce_out        0.1
// -- -------------------------------------------------------------
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: butterbp
// Source Path: untitled/butterbp
// Hierarchy Level: 0
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module butterbp
          (clk,
           reset,
           clk_enable,
           In,
           ce_out,
           Out);


  input   clk;
  input   reset;
  input   clk_enable;
  input   signed [13:0] In;  // sfix14_En13
  output  ce_out;
  output  signed [17:0] Out;  // sfix18_En13


  wire enb;
  wire enb_8_1_1;
  wire enb_1_1_1;
  wire signed [17:0] filter_out1_reg;  // sfix18_En13
  reg signed [17:0] filter_out1;  // sfix18_En13


  butterbp_tc u_butterbp_tc (.clk(clk),
                             .reset(reset),
                             .clk_enable(clk_enable),
                             .enb_8_1_1(enb_8_1_1),
                             .enb(enb),
                             .enb_1_1_1(enb_1_1_1)
                             );

  filter u_filter (.clk(clk),
                   .enb_8_1_1(enb_8_1_1),
                   .reset(reset),
                   .filter_in(In),  // sfix14_En13
                   .filter_out(filter_out1_reg)  // sfix18_En13
                   );
  always @(posedge clk)
    begin : filter_reg_process
      if (reset == 1'b1) begin
        filter_out1 <= 18'sb000000000000000000;
      end
      else begin
        if (enb) begin
          filter_out1 <= filter_out1_reg;
        end
      end
    end



  assign Out = filter_out1;

  assign ce_out = enb_1_1_1;

endmodule  // butterbp
