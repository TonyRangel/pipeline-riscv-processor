`timescale 1ns / 1ps
module UART_TX (
//Inputs: TX (8sw, 1 button), RX(1 GPIO)
	input clk,
	input n_rst,
	input [7:0] data,
	input btn_tx,
	output tx_line,
	output wb,
	output finish,
	output busy
	);
	
/////UART Transmiter.________________________________________________________________________
wire parity_tx;
assign parity_tx = ^data;  //defined parity bit for transmiter

//All wire to connect every instance
wire rst_bit_counter_tx, bit_counter_en_tx, rst_wait_tx, bit_wait_tx, end_bit_time, bit_enable_start, bit_shift_en_tx;
wire [3:0]count_bits_t;

// For a baud rate of 9600 baudios: bit time 104.2 us, half time 52.1 us
// For a clock frequency of 50 MHz bit time = 5210 T50MHz;

Bit_Rate_Pulse # (.delay_counts(5208) ) BR_pulse_tx (//5208
.clk(clk), 
.rst(rst_wait_tx), 
.enable(bit_wait_tx), 
.end_bit_time(end_bit_time) 
);

//FSM:instance to drive the states for out TX system; Init, Start, Wait, Shift Register, Stop.				
FSM_UART_tx FSM_tx(
.tx(btn_tx), 
.clk(clk), 
.rst(n_rst), 
.end_bit_time_t(end_bit_time), 
.Tx_bit_Count(count_bits_t), 
.bit_counter_en_tx(bit_counter_en_tx),
.bit_enable_start(bit_enable_start), 
.bit_shift_en_tx(bit_shift_en_tx), 
.bit_wait_tx(bit_wait_tx), 
.rst_wait_tx(rst_wait_tx), 
.rst_bit_counter_tx(rst_bit_counter_tx),
.wb(wb),
.finish(finish),
.busy(busy)
);

//Instace to count 9 bits to send (8 data bist, 1 parity bit)	 
Counter_Param # (.n(4) ) Counter_bits_tx (
.clk(clk), 
.rst(rst_bit_counter_tx), 
.enable(bit_counter_en_tx), 
.Q(count_bits_t)    
);

//Instance where input register is shift to TX_Line, after WAIT intance.
TXshift_register SR(
 .clk(clk),
 .rst(n_rst),
 .en_start(bit_enable_start),
 .en_shift(bit_shift_en_tx),
 .Sw({parity_tx,data,1'b0}),
 .ser_bit(tx_line)
);

//Instance to control button bouncing, to avoind many high levels.
//btn_control bCtrl(
//  .BtnRst(n_rst),
//  .BtnStrt(btn_tx),
//  .clk(clk),
//  .OutStrt(OutStrt),
//  .OutRst(OutRst)
//);

endmodule