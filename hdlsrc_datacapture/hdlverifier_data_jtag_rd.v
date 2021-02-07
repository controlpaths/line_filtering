
/*-- ----------------------------------------------
-- File Name: hdlverifier_data_jtag_rd.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/

module hdlverifier_data_jtag_rd #(parameter DATA_WIDTH = 8,
                                            ADDR_WIDTH = 5)
   (
    input  							clk,
    input  							reset,
    input  							shift_out_state,
    input  							shift_out_en,
	input  							newChunk,
	input        [ADDR_WIDTH-1:0] 	chunkSize,
    output 							shift_out_data,
    output reg                  	rd,
    input  		 [DATA_WIDTH-1:0] 	rd_data,
    output reg   [ADDR_WIDTH-1:0] 	raddr,
    output reg  					rdy_send
    );

    reg            [15:0] bitcount;
    reg            [15:0] bitcount_d1;
    reg            [15:0] bitcount_d2;
    reg  [DATA_WIDTH-1:0] shift_reg;
	reg  [ADDR_WIDTH-1:0] stop_raddr; // end address of current chunk
	reg 				  newChunk_d1;
	reg                   rd_d1;
	reg                   rd_d2;
	reg                   rd_d3;
	
//----- data out to jtag
assign shift_out_data = (shift_out_en && (rd_d2)) ? shift_reg[0]:1'b0;
//assign shift_out_data = shift_reg[0];

always @ (posedge clk)
begin
    newChunk_d1 <= newChunk;
end

always @(posedge clk )
begin
	if(reset) begin
		rd <= 0;
	end
	else begin
		if(newChunk & (!newChunk_d1)) begin
			rd <= 1'b1;
			stop_raddr <= raddr + chunkSize - 1;
		end
		else if((stop_raddr == raddr) && (bitcount == DATA_WIDTH - 1))
		begin
		    rd <= 1'b0;
		end
	end
end


always @ (posedge clk)
begin
    if(reset)
        rd_d1 = 0;
    else
        rd_d3 = rd_d2;
        rd_d2 = rd_d1;
        rd_d1 = rd;
end



always @(posedge clk)
begin
	if(reset)begin
		rdy_send <= 1'b0;
	end
	else begin
		if(rd_d3 == 0) begin
			rdy_send <= 1'b1;
		end
		else begin
			rdy_send <= 1'b0;
		end
	end
end

//---- transferring captured data to JTAG 
always @(posedge clk) begin
  if(reset ) begin
    bitcount  <=   0;
    shift_reg <=   0;
    raddr     <= 'd0;
  end if(rdy_send) begin
    shift_reg <= 0;
    bitcount <= 0;
  end else begin
    if (shift_out_en && (rd || rd_d2)) begin
      if(bitcount == 0) begin
        shift_reg <= {1'b0,shift_reg[DATA_WIDTH-1:1]};
        bitcount  <= bitcount + 1'b1;
        raddr     <= raddr;
      end else if(bitcount == 1) begin
        bitcount  <= bitcount + 1'b1; 
        shift_reg <= rd_data;
        raddr     <= raddr;
      end else if(bitcount == (DATA_WIDTH-1)) begin
        bitcount  <= 0;
        shift_reg <= {1'b0,shift_reg[DATA_WIDTH-1:1]};
        raddr     <= raddr + 'd1;
      end else begin
        bitcount  <= bitcount + 1'b1; 
        shift_reg <= {1'b0,shift_reg[DATA_WIDTH-1:1]};
        raddr     <= raddr;
      end
    end        
  end
end

endmodule
