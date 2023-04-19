`timescale 1ns / 1ps
module RISC_V_Single_Cycle_UART_tb;

reg clk, rst;
reg [7:0] GPIOin;
wire [7:0] GPIOout;
reg UARTRx;
wire UARTTx;

RISC_V_Single_Cycle UUT(
 .clk(clk),
 .reset(rst),
 .GPIO_in(GPIOin),
 .GPIO_out(GPIOout),
 .uart_rx(UARTRx),
 .uart_tx(UARTTx)
 
);

initial 
	begin
	UARTRx = 1'b1;
	clk = 1'b1;
	rst = 1'b1;
	GPIOin = 8'b00000101;
#2 rst = 1'b0;

#118 UARTRx = 1'b0;
#120 UARTRx = 1'b0;

/*#118 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b1;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b1;

#1800 UARTRx = 1'b0;
#120 UARTRx = 1'b1;
#120 UARTRx = 1'b1;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b1;


#18000 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b1;
#120 UARTRx = 1'b1;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b0;
#120 UARTRx = 1'b1;*/
	end
always // Clock generator
  begin
    #5 clk = ~clk;
  end
endmodule