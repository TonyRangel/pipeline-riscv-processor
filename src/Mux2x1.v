///////////////////////////////////////////////
//Company: ITESO
//Engineer: Antonio Rangel Avila  
//Module Description: Multiplexor funtion 4 inputs, one output;parameterized;
//Date: Sep 15th 2022
///////////////////////////////////////////////
module Mux2x1 #(parameter DATA_WIDTH = 32)
(
	input		   Selector,
	input			[DATA_WIDTH-1:0]	I_0,
	input			[DATA_WIDTH-1:0]	I_1,

	
	output reg 	[DATA_WIDTH-1:0]	Mux_Out
);

	always@(*) begin
		case (Selector)
			0	:	Mux_Out = I_0;
			1	:	Mux_Out = I_1;

		endcase	
	end	
endmodule