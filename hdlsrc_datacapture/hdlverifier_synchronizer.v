
/*-- ----------------------------------------------
-- File Name: hdlverifier_synchronizer.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/


module hdlverifier_synchronizer #(parameter WIDTH = 10)(
    input clk,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

reg [WIDTH-1:0] data_reg;

always@(posedge clk) begin
    begin
        data_reg <= data_in;
        data_out <= data_reg;
    end
end
    
endmodule