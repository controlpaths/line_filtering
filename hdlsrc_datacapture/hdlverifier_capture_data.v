
/*-- ----------------------------------------------
-- File Name: hdlverifier_capture_data.v
-- Created:   31-Dec-2020 10:05:10
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------*/

module hdlverifier_capture_data #(parameter DATA_WIDTH = 8,
                                            ADDR_WIDTH = 5)(
// Signals coming from user's design                              
    input clk,
    input clk_enable,
    input [DATA_WIDTH-1:0] data,
    input trigger,
    input [ADDR_WIDTH-1:0] trigger_pos,
    input [ADDR_WIDTH-1:0] number_of_windows,
	output reg ready_to_capture,						 
     
// Signals coming from JTAG controller, but in clk domain
    input  reset,
    input  run,
    input  run_tck,
    input  immediate,
    output flag_full,
    output has_clk,
    
	//---- windows captured status to user
    output reg [ADDR_WIDTH-1:0] captured_window_count,

	// Signals interfacing with JTAG controller, but in tck domain
    input  tck,
	input                  rd,
	input  [ADDR_WIDTH-1:0] raddr,
	output [DATA_WIDTH-1:0] rd_data
);

localparam DEPTH = 2**ADDR_WIDTH;
localparam DEPTH_MS2 = DEPTH-2;
localparam DEPTH_MS1 = DEPTH-1;							   
localparam STATE_IDLE        = 2'd0,
           STATE_CAPTURE_PRE = 2'd1, //fill data before trigger
           STATE_CAPTURE_POS = 2'd2, //fill data after trigger
           STATE_FULL        = 2'd3;

wire internal_trigger = trigger | immediate;
                

//---- write to memory signals
reg                   wr;
reg                   wr_d1;
reg  [ADDR_WIDTH-1:0] waddr;
reg  [DATA_WIDTH-1:0] data_wtrigger_info;
reg  [ADDR_WIDTH-1:0] ram_waddr;

//---- 
reg                   reg_full;
reg                   reg_clk;
reg  [ADDR_WIDTH-1:0] wr_window_count_by1;
reg  [ADDR_WIDTH-1:0] wr_window_count_gray;
wire [ADDR_WIDTH-1:0] wr_window_count_gray_tckreg;
wire [ADDR_WIDTH-1:0] wr_window_count_bintck;
reg                   windw_captured_int;
reg                   windw_captured;
wire                  windw_captured_tck;
reg                   windw_captured_tck_d1;
reg                   windw_captured_tck_ed;

//---- FSM & internal signals
reg             [1:0] state_reg;

reg  [ADDR_WIDTH-1:0] window_size;
reg    [ADDR_WIDTH:0] window_size_plus1;
reg                   trigpos_eq_depth;
reg                   trigpos_eq_zero;
reg                   trigpos_nteq_zero;
reg  [ADDR_WIDTH-1:0] trigpos_ms1;
reg  [ADDR_WIDTH-1:0] windsze_ms_trig_pos;
reg  [ADDR_WIDTH-1:0] memory_depth_ms_windsz;
wire                  waddr_eq_windsz;
wire                  trigcond_met;
reg                   trigcond_met_tck;
reg                   capture_valid;
reg  [ADDR_WIDTH-1:0] pos_counter;
reg  [ADDR_WIDTH-1:0] pre_counter;
reg                   run_d1;
reg  [ADDR_WIDTH-1:0] wr_window_count;
reg                   trigcond_met_d1;									  
reg                   trigger_bitinfo;

//---- read from memory signals
reg            [15:0] bitcount;
reg  [DATA_WIDTH-1:0] shift_reg;

//---- write enable
always@(*) begin
    wr = (state_reg == STATE_CAPTURE_PRE && clk_enable) ? 1'b1:
                (state_reg == STATE_CAPTURE_POS && clk_enable) ? 1'b1:
                1'b0;
end

//----  required for pipelining write
always @(posedge clk) begin
  //---- #1 latency
  if (reset)
    wr_d1    <= 1'd0;
  else if (clk_enable)
    wr_d1    <= wr;
  else
    wr_d1    <= 1'd0;
end

//---- register full status
always@(posedge clk or posedge reset) begin
    if(reset) begin
        reg_full <= 1'b0;
        reg_clk  <= 1'b0;
    end
    else begin
        reg_full <= (state_reg ==  STATE_FULL);    
        reg_clk  <= 1'b1;
    end
end            

hdlverifier_synchronizer #(.WIDTH(1)) s1(
    .clk(tck),
    .data_in(reg_full),
    .data_out(flag_full)
);

hdlverifier_synchronizer #(.WIDTH(1)) s2(
    .clk(tck),
    .data_in(reg_clk),
    .data_out(has_clk)
);

//----- For user to indicate whether trigger conditions being met or not
//---- window count information user about captured window
always @(posedge clk) begin
  if ((reset) || (!run))
    wr_window_count_by1 <= 'd0;
  else if (clk_enable) begin
    if ((trigcond_met == 1'd1) && (state_reg == STATE_CAPTURE_PRE)) begin
      if (trigpos_eq_depth == 1'd1)
        wr_window_count_by1 <= wr_window_count_by1 + 'd1;
    end else if (state_reg == STATE_CAPTURE_POS) begin
      if (pos_counter == windsze_ms_trig_pos)
        wr_window_count_by1 <= wr_window_count_by1 + 'd1;
    end
  end else
    wr_window_count_by1 <= wr_window_count_by1;
end

//---- Binary to Gray
always @(posedge clk) begin
  wr_window_count_gray <=  (wr_window_count_by1 >> 1) ^ wr_window_count_by1;  
end

//---- clock domain crossing
hdlverifier_synchronizer #(.WIDTH(ADDR_WIDTH)) s3(
    .clk(tck),
    .data_in(wr_window_count_gray),
    .data_out(wr_window_count_gray_tckreg)
);

//---- Gray to Binary
generate genvar i;
  for (i=0; i<ADDR_WIDTH; i=i+1) begin : gen_bin
    assign wr_window_count_bintck[i] = ^(wr_window_count_gray_tckreg>>i);
  end
endgenerate

//---- clock domain crossing
always @(posedge tck) begin
  captured_window_count     <= wr_window_count_bintck;
end
//---- window size based on memory capture depth and number_of_windows
//---- #1 latency
always @ (posedge clk)
  window_size    <=  ((DEPTH) >> number_of_windows) - 1;

//---- window_size depth plus 1 at design clock
//---- #2 latency
always @ (posedge clk)
  window_size_plus1 <= window_size + 'd1;

//---- trigger position equal to window size
//---- #1 latency
always @ (posedge clk)
  trigpos_eq_depth   <= (trigger_pos == window_size);

//---- trigger position equal to zero
//---- #1 latency
always @ (posedge clk)
  trigpos_eq_zero   <= (trigger_pos == 'd0);

//---- trigger position not equal to zero
//---- #1 latency
always @ (posedge clk)
  trigpos_nteq_zero   <= (trigger_pos != 'd0);

//---- trigger position minus 1
//---- #1 latency
always @ (posedge clk)
  trigpos_ms1   <= (trigger_pos - 'd1);
  
//---- window size minus trigger position
//---- #1 latency
always @ (posedge clk)
  windsze_ms_trig_pos <= (window_size - trigger_pos) -1;

//---- memory depth minus window size
//---- #1 latency
always @ (posedge clk)
  memory_depth_ms_windsz <= ((DEPTH) - (window_size_plus1));

//---- write address equal to window_size
assign waddr_eq_windsz   = (waddr == (window_size));

//---- trigger condition met, when trigger input and capture valid is high
assign trigcond_met        = ((internal_trigger == 1'd1) && (capture_valid == 1'd1));


//---- capture valid goes high when pre counter reaches or equal to trigger position
//---- Will go HIGH if trigger position is zero and when run is HIHG to capture each clock cycle 
//---- Goes LOW when trigger condition met and trigger position is not zero, not making LOW when triggerposition is zero to capture the every trigger
always @(posedge clk) begin      
  if (reset)
    capture_valid <= 1'd0;
  else if ((clk_enable) && (trigcond_met) && (trigpos_nteq_zero))
    capture_valid <= 1'd0;
  else if ((!run_d1 && run) && (trigpos_eq_zero))
    capture_valid <= 1'd1;
  else if (state_reg == STATE_IDLE)
    capture_valid <= 1'd0;
  else if ((clk_enable) && (pre_counter >= (trigpos_ms1)) && (state_reg == STATE_CAPTURE_PRE))
    capture_valid <= 1'd1;
  else
    capture_valid <= capture_valid;
end

//---- FSM - state machine to capture data
//---- when state is 'STATE_CAPTURE_PRE' and 'STATE_CAPTURE_POS' the data is written to memory.
//---- if number of windows greater than '1' then the memory is break down based on it.
//---- storing write address for each window, required when reading the captured data

always@(posedge clk) begin
  if(reset) begin
    state_reg       <= STATE_IDLE;
    run_d1          <= 1'd0;
    pos_counter     <= 'd0;
    pre_counter     <= 'd0;
    waddr           <= 'd0;
  end else if (!run) begin
    state_reg       <= STATE_IDLE;
    run_d1          <= 1'd0;
    pre_counter     <= 'd0;
    pos_counter     <= 'd0;
    waddr           <= 'd0;
  end else begin
    case(state_reg)
      STATE_IDLE: begin
        waddr           <= 'd0;
        run_d1          <= run;
        pos_counter     <= 'd0;
        pre_counter     <= 'd0;
                 
        if(!run_d1 && run)
            state_reg <= STATE_CAPTURE_PRE;
      end
                
      //---- capturing data till trigger posiiotn, when trigger met 
      STATE_CAPTURE_PRE: begin
        if(clk_enable) begin
          
          //---- write address loop to zero when window depth reached
          if (waddr_eq_windsz)
            waddr <= 'd0;
          else
            waddr <= waddr + 'd1;

	      //---- pre counter
          if (trigcond_met && trigpos_eq_depth)
            pre_counter <= 'd0;
          else
            pre_counter <= pre_counter + 1'b1;
                    
          //---- trigger condition met, when trigger input and capture valid is high
          //---- based on the trigger position and capture depth and number of windows state machine control moves 
          if(trigcond_met == 1'd1) begin
            if(trigger_pos != window_size)
              state_reg <= STATE_CAPTURE_POS;
            else if ((trigpos_eq_depth == 1'd1) && (wr_window_count == memory_depth_ms_windsz))
              state_reg <= STATE_FULL;
            else if (trigpos_eq_depth == 1'd1)
              state_reg <= STATE_CAPTURE_PRE;
            else
              state_reg <= STATE_CAPTURE_PRE;
          end                    
        end
      end

      //---- capture data after trigger and trigger position
      STATE_CAPTURE_POS: begin
        if(clk_enable) begin                    
           //---- initilize to zero
           pre_counter <= 'd0;

          //---- write address loop to zero when window depth reached
          if (waddr_eq_windsz)
            waddr <= 'd0;
          else
            waddr <= waddr + 'd1;

          if ((pos_counter == windsze_ms_trig_pos) && (wr_window_count == memory_depth_ms_windsz)) begin
            state_reg   <= STATE_FULL;
            pos_counter <= 'd0;                    
          end else if (pos_counter == windsze_ms_trig_pos) begin
            state_reg   <= STATE_CAPTURE_PRE;
            pos_counter <= 'd0;                    
          end else begin
            state_reg   <= STATE_CAPTURE_POS;
            pos_counter <= pos_counter + 'd1;                    
          end
        end
      end
                    
      STATE_FULL: begin
        if(!run) begin
          state_reg <= STATE_IDLE;
        end
      end
      
      default: 
        state_reg <= STATE_IDLE;
    endcase
  end
end


//---- write window count
always @(posedge clk) begin
  if ((reset) || (state_reg == STATE_IDLE))
    wr_window_count <= 'd0;
  else if (clk_enable) begin
    if ((trigcond_met == 1'd1) && (state_reg == STATE_CAPTURE_PRE)) begin
      if (trigpos_eq_depth == 1'd1)
        wr_window_count <= wr_window_count + window_size_plus1;
    end else if (state_reg == STATE_CAPTURE_POS) begin
      if (pos_counter == windsze_ms_trig_pos)
        wr_window_count <= wr_window_count + window_size_plus1;
    end
  end else
    wr_window_count <= wr_window_count;
end

//---- #1 latency
always @ (posedge clk) begin
  ram_waddr <= wr_window_count + waddr;
end


//---- data with trigger condition met information, 1 bit at msb indicates trigger condition met and include pad zeros if data width not in bytes range rest is the data 
//---- #1 latency
always @ (posedge clk) begin
  if (reset)
    trigcond_met_d1 <= 1'b0;
  else
    trigcond_met_d1 <= trigcond_met && clk_enable;
end

always @ (*) begin
  if ((state_reg == STATE_CAPTURE_PRE) && (trigcond_met)) begin
    if (trigpos_eq_zero)
	  trigger_bitinfo = 1'd1;
	else if (trigcond_met_d1 == 1'd0)
	  trigger_bitinfo = 1'd1;
	else
	  trigger_bitinfo = 1'd0;
  end else
    trigger_bitinfo = 1'd0;
end

always @ (posedge clk) begin
  data_wtrigger_info <= {trigger_bitinfo, data[DATA_WIDTH-2:0]};
end


//---- Memory for pre and pos capture of data
hdlverifier_dcram #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) u_dcram(
    .wdata(data_wtrigger_info),
    .raddr(raddr),
    .waddr(ram_waddr),
    .wr(wr_d1),
    .rd(rd),
    .rclk(tck),
    .wclk(clk),
    .q(rd_data));
    
 
//---- when Matlab armed i.e run is high and clock enable and trigger high then it goes HIGH else if Flag is full then it goes LOW
//---- indicating user design that data capture ip is ready to capture data
always @(posedge clk)
begin
  if ((reset) || (!run))
    ready_to_capture <= 1'd0;
  else if (clk_enable)
  begin
    if (waddr == (DEPTH_MS2))
      ready_to_capture <= 1'd0;
    else if (waddr == DEPTH_MS1)
      ready_to_capture <= 1'd0;
  end
  else if (waddr == (DEPTH_MS1))
    ready_to_capture <= ~ready_to_capture;
  else if (state_reg ==  STATE_FULL)
    ready_to_capture <= 1'd0;
  else if (run && (trigger || immediate))
    ready_to_capture <= 1'd1;
end
	 
endmodule