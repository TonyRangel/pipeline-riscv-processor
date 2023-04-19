///////////////////////////////////////////////
//Company: ITESO
//Engineer: Antonio Rangel Avila  
//Module Description: Multiplexor funtion 4 inputs, one output;parameterized;
//Date: Sep 15th 2022
///////////////////////////////////////////////
module Mux4x1 #(parameter DATA_WIDTH = 32)
(
	input			[1:0]					Selector,
	input			[DATA_WIDTH-1:0]	I_0,
	input			[DATA_WIDTH-1:0]	I_1,
	input			[DATA_WIDTH-1:0]	I_2,
	input			[DATA_WIDTH-1:0]	I_3,
	
	output reg 	[DATA_WIDTH-1:0]	Mux_Out
);

	always@(*) begin
		case (Selector)
			0	:	Mux_Out = I_0;
			1	:	Mux_Out = I_1;
			2	:	Mux_Out = I_2;
			3	:	Mux_Out = I_3;
		endcase	
	end	
endmodule