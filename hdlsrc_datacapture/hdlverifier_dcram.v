
/*-- ----------------------------------------------
-- File Name: hdlverifier_dcram.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/


module hdlverifier_dcram #(parameter DATA_WIDTH = 8,
                                     ADDR_WIDTH = 5)(
    input [DATA_WIDTH - 1:0] wdata,
    input [ADDR_WIDTH - 1:0] raddr, 
    input [ADDR_WIDTH - 1:0] waddr,
    input wr,
    input rd, 
    input rclk, 
    input wclk,
    output reg [DATA_WIDTH - 1:0] q
);
    localparam DEPTH = 2**ADDR_WIDTH;

    // The RAM variable
    (* ramstyle = "no_rw_check" *) reg [DATA_WIDTH - 1:0] ram [DEPTH - 1:0]; 
    
    // Write
    always @ (posedge wclk) begin       
        if (wr)
            ram[waddr] <= wdata;
    end
    
    // Read 
    always @ (posedge rclk) begin
        if (rd)
            q <= ram[raddr];
    end
endmodule
