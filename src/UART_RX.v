module UART_RX (
//Inputs: TX (8sw, 1 button), RX(1 GPIO)
	input clk,
	input n_rst,
	input rx_line,
	output [7:0] data,
	output finish,
	output busy
);

wire endBit, EnBitCnt, ShiftEn, WaitEn, RstWait, RstBitCnt;
wire [3:0] BitCnt;

Bit_Rate_Pulse # (.delay_counts(2604) ) BR_pulse_rx (//2604
.clk(clk), 
.rst(RstWait), 
.enable(WaitEn), 
.end_bit_time(endBit) 
);

FSM_UART_rx FSM_rx(
.rx(rx_line),
.clk(clk),
.rst(n_rst),
.end_bit_time_t(endBit), //Bit rate flag
.Rx_bit_Count(BitCnt), //Count to 9 for 8bits data and 1 parity bit
.bit_counter_en_rx(EnBitCnt), //enable for counter
.bit_shift_en_rx(ShiftEn), //
.bit_WAIT_RX(WaitEn), //enable to bit rate.
.rst_WAIT_RX(RstWait), //rst for bit rate (idle TX line)
.rst_bit_counter_rx(RstBitCnt), //rst for counter bits.
.finish(finish),
.busy(busy)
);

//Instace to count 9 bits to send (8 data bist, 1 parity bit)	 
Counter_Param # (.n(4) ) Counter_bits_rx (
.clk(clk), 
.rst(RstBitCnt), 
.enable(EnBitCnt), 
.Q(BitCnt)    
);

RXshift_register SR(
 .clk(clk),
 .rst(n_rst),
 .en_start(ShiftEn),
 .Sw(data),
 .ser_bit(rx_line)
);
endmodule	