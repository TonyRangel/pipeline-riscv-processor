module UART
(
input clk,
input rst,
input wrtEn,
input addr,
input [31:0] TxData,
input SerialIn,
output [31:0] ReadReg,
output SerialOut
);

wire [31:0] TxRegD, RxRegD;
wire [7:0] TxBits31_24, RxData;
wire TxBusy, TxBit0, RegEn, Txfinish, UARTwrt, RxFinish,RxBusy, clrRxFin;
assign TxBit0 = (Txfinish == 1'b1)? 1'b0:TxData[0];
assign RegEn = wrtEn | UARTwrt;
assign TxBits31_24 = (TxBusy == 1'b1)? 8'b0: TxData[31:24]; 
assign ReadReg = (addr == 1'b0)? TxRegD: RxRegD;
Register #(.DATA_WIDTH(32)) TXReg(
.D({TxBits31_24,{22{1'b0}},TxBusy,TxBit0}),
.RST_D(32'h0000_0000),
.rst(rst),
.en(RegEn),
.clk(clk),
.Q(TxRegD)
);
assign clrRxFin = RxFinish | (RxRegD[9] & ((addr == 1'b1 && wrtEn == 1'b1)? 1'b0: 1'b1));
Register #(.DATA_WIDTH(32)) RXReg(
.D({{22{1'b0}},clrRxFin,RxBusy,RxData}),
.RST_D(32'h0000_0000),
.rst(rst),
.en(1'b1),
.clk(clk),
.Q(RxRegD)
);
UART_TX TX(
	.clk(clk),
	.n_rst(rst),
	.data(TxRegD[31:24]),
	.btn_tx(TxRegD[0]),
   .tx_line(SerialOut),
	.wb(UARTwrt),
	.busy(TxBusy),
	.finish(Txfinish)
);
UART_RX RX(
.clk(clk),
.n_rst(rst),
.rx_line(SerialIn),
.data(RxData),
.finish(RxFinish),
.busy(RxBusy)
);

endmodule