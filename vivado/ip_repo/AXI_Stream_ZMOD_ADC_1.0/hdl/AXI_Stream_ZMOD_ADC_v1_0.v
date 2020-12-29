
`timescale 1 ns / 1 ps

module AXI_Stream_ZMOD_ADC_v1_0 #
(
		// Users to add parameters here
		parameter PRESCALER = 0,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
		/* DDR signals */
		input [15:0] adc_ddr_data, /* Parallel input data from ADC */
		input adc_ddr_clk, /* Input clock select*/

		output adc_configured, /* Adc configuration complete signal */

		/* SPI signals */
		input clk_spi, /* Input clock for SPI. or_sclk = clk_spi/4*/
		output sck, /* ADC SPI clk out */
		output cs, /* ADC SPI data IO  */
		output sdio, /* ADC SPI cs out */

		/* Differential output clock */
		input adc_clk,
		output adc_clkout_p, /* ADC differential output clock p*/
		output adc_clkout_n, /* ADC differential output clock n*/

		/* ZMOD configuration signals */
		output zmod_adc_coupling_h_a, /* ZMOD ADC input coupling select for of channel A. Differential driver */
		output zmod_adc_coupling_l_a, /* ZMOD ADC input coupling select for of channel A. Differential driver */
		output zmod_adc_coupling_h_b, /* ZMOD ADC input coupling select for of channel B. Differential driver */
		output zmod_adc_coupling_l_b, /* ZMOD ADC input coupling select for of channel B. Differential driver */
		output zmod_adc_gain_h_a, /* ZMOD ADC input gain select for of channel A. Differential driver */
		output zmod_adc_gain_l_a, /* ZMOD ADC input gain select for of channel A. Differential driver */
		output zmod_adc_gain_h_b, /* ZMOD ADC input gain select for of channel B. Differential driver */
		output zmod_adc_gain_l_b, /* ZMOD ADC input gain select for of channel B. Differential driver */
		output zmod_adc_com_h, /* ZMOD ADC commom signal. Differential driver*/
		output zmod_adc_com_l, /* ZMOD ADC commom signal. Differential driver*/
		output o_adc_sync, /* ZMOD ADC SYNC signal */
		// User ports ends
		// Do not modify the ports beyond this line

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		input wire  m00_axis_tready
	);

	/* ADC master clock */
	wire clkadc_ddr; /* ADC clock. This clock is used to generate the output differential clock */

	/* Clock forwarding for ADC. Differential clock */
  ODDR #(
  .DDR_CLK_EDGE("SAME_EDGE"),
  .INIT(1'b0),
  .SRTYPE("SYNC")
  )ODDR_CLKADC(
  .Q(clkadc_ddr),
  .C(adc_clk),
  .CE(1'b1),
  .D1(1'b0),
  .D2(1'b1),
  .R(rst),
  .S(1'b0)
  );

  OBUFDS #(
  .IOSTANDARD("DEFAULT"),
  .SLEW("SLOW")
  ) OBUFDS_CLKADC (
  .O(adc_clkout_p),
  .OB(adc_clkout_n),
  .I(clkadc_ddr)
  );

	/* ADC input configuration */
	assign o_zmod_adc_coupling_h_a = 1'b0;
	assign o_zmod_adc_coupling_l_a = 1'b1;
	assign o_zmod_adc_coupling_h_b = 1'b0;
	assign o_zmod_adc_coupling_l_b = 1'b1;
	assign o_zmod_adc_gain_h_a = 1'b0;
	assign o_zmod_adc_gain_l_a = 1'b1;
	assign o_zmod_adc_gain_h_b = 1'b0;
	assign o_zmod_adc_gain_l_b = 1'b1;
	assign o_adc_sync = 1'b0;
	assign o_zmod_adc_com_h = 1'b0;
	assign o_zmod_adc_com_l = 1'b0;

	/* Driver module instance */
	axis_zmod_adc_driver_v1_0 axis_zmod_adc_driver_inst0 (
	.aclk(m00_axis_aclk), /* Clock input */
	.rstn(m00_axis_aresetn), /* Reset input */
	.axis_tready(m00_axis_tready), /* AXIS tready input */
	.axis_tvalid(m00_axis_tvalid), /* AXIS tvalid output */
	.axis_tdata(m00_axis_tdata), /* AXIS tdata output */
	.i14_data(adc_ddr_data), /* Parallel input data from ADC */
	.i_dco(adc_ddr_clk), /* Input clock select*/
	.i32_prescaler(PRESCALER), /* Input for clock prescaler */
	.o_adc_configured(adc_configured), /* Adc configuration complete signal */
	.clk_spi(clk_spi), /* Input clock for SPI. or_sclk = clk_spi/4*/
	.or_sck(sck), /* ADC SPI clk out */
	.or_cs(cs), /* ADC SPI data IO  */
	.o_sdio(sdio) /* ADC SPI cs out */
	);

	endmodule
