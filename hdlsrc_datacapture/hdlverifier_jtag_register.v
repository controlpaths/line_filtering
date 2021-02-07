
/*-- ----------------------------------------------
-- File Name: hdlverifier_jtag_register.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/


module hdlverifier_jtag_register 
(
// Clock domain: tck
    input tck,    
    input reset,
    input [4:0] addr,
    input [31:0] wdata,
    input write,
    output reg [31:0] rdata,
// Clock domain clk
    input clk,
    input [31:0] user_data_in0,
    input [31:0] user_data_in1,
    input [31:0] user_data_in2,
    input [31:0] user_data_in3,
    output [31:0] user_data_out0_tck,
    output [31:0] user_data_out0,
    output [31:0] user_data_out1,
    output [31:0] user_data_out2,
    output [31:0] user_data_out3    
);

reg [31:0] write_data[0:3];
wire [31:0] read_data[0:3];

assign user_data_out0_tck = write_data[0];

always@(posedge tck) begin
    if (reset) begin
        write_data[0] <= 32'b0;
        write_data[1] <= 32'b0;
        write_data[2] <= 32'b0;
        write_data[3] <= 32'b0;
    end
    else if(write) begin
        case(addr[1:0]) 
            2'b00:
                write_data[0] <= wdata;
            2'b01:
                write_data[1] <= wdata;
            2'b10:
                write_data[2] <= wdata;
            2'b11:
                write_data[3] <= wdata;
            default:
                write_data[0] <= wdata;
        endcase
    end
end

hdlverifier_synchronizer #(.WIDTH(32)) s0(
    .clk(clk),
    .data_in(write_data[0]),
    .data_out(user_data_out0)
);
hdlverifier_synchronizer #(.WIDTH(32)) s1(
    .clk(clk),
    .data_in(write_data[1]),
    .data_out(user_data_out1)
);
hdlverifier_synchronizer #(.WIDTH(32)) s2(
    .clk(clk),
    .data_in(write_data[2]),
    .data_out(user_data_out2)
);
hdlverifier_synchronizer #(.WIDTH(32)) s3(
    .clk(clk),
    .data_in(write_data[3]),
    .data_out(user_data_out3)
);

always@(posedge tck) begin
    case(addr[1:0]) 
        2'b00:
            rdata <= read_data[0];
        2'b01:
            rdata <= read_data[1];
        2'b10:
            rdata <= read_data[2];
        2'b11:
            rdata <= read_data[3];
        default:
            rdata <= read_data[0];
    endcase
end

hdlverifier_synchronizer #(.WIDTH(32)) t0(
    .clk(tck),
    .data_in(user_data_in0),
    .data_out(read_data[0])
);

hdlverifier_synchronizer #(.WIDTH(32)) t1(
    .clk(tck),
    .data_in(user_data_in1),
    .data_out(read_data[1])
);
hdlverifier_synchronizer #(.WIDTH(32)) t2(
    .clk(tck),
    .data_in(user_data_in2),
    .data_out(read_data[2])
);
hdlverifier_synchronizer #(.WIDTH(32)) t3(
    .clk(tck),
    .data_in(user_data_in3),
    .data_out(read_data[3])
);

endmodule