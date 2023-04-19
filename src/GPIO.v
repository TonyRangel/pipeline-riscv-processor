module GPIO(
	input clk,
	input rst,
	input en,
	input addr,
	input [31:0]DataToOut,
	input [7:0]PORT_IN,
	output [7:0]PORT_OUT,
	output [31:0]DataFromIn
);
wire [31:0]ToOut, FromIn;
assign DataFromIn = (addr == 1'b0)? ToOut:FromIn;
assign PORT_OUT = ToOut[7:0];
Register #(.DATA_WIDTH(32)) InReg(
.D({{24{1'b0}},PORT_IN}),
.RST_D(32'h0000_0000),
.rst(rst),
.en(1'b1),
.clk(clk),
.Q(FromIn)
);

Register #(.DATA_WIDTH(32)) OutReg(
.D(DataToOut),
.RST_D(32'h0000_0000),
.rst(rst),
.en(en),
.clk(clk),
.Q(ToOut)
);

endmodule