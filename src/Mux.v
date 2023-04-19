///////////////////////////////////////////////
//Company: ITESO
//Engineer: Antonio Rangel Avila  
//Module Description: Multiplexor funtion 2 inputs, one output;parameterized;
//Date: Sep 15th 2022
///////////////////////////////////////////////
module Mux #(parameter WIDTH = 32)(
input [4:0]       Sel,

input [WIDTH-1:0] Din0, 
input [WIDTH-1:0] Din1,
input [WIDTH-1:0] Din2,
input [WIDTH-1:0] Din3,
input [WIDTH-1:0] Din4,
input [WIDTH-1:0] Din5,
input [WIDTH-1:0] Din6,
input [WIDTH-1:0] Din7,
input [WIDTH-1:0] Din8,
input [WIDTH-1:0] Din9,
input [WIDTH-1:0] Din10,
input [WIDTH-1:0] Din11,
input [WIDTH-1:0] Din12,
input [WIDTH-1:0] Din13,
input [WIDTH-1:0] Din14,
input [WIDTH-1:0] Din15,
input [WIDTH-1:0] Din16,
input [WIDTH-1:0] Din17,
input [WIDTH-1:0] Din18,
input [WIDTH-1:0] Din19,
input [WIDTH-1:0] Din20,
input [WIDTH-1:0] Din21,
input [WIDTH-1:0] Din22,
input [WIDTH-1:0] Din23,
input [WIDTH-1:0] Din24,
input [WIDTH-1:0] Din25,
input [WIDTH-1:0] Din26,
input [WIDTH-1:0] Din27,
input [WIDTH-1:0] Din28,
input [WIDTH-1:0] Din29,
input [WIDTH-1:0] Din30,
input [WIDTH-1:0] Din31,

output reg [WIDTH-1:0] Dout );



always @ (*) begin
    case(Sel)
	     5'b00000    : Dout = Din0;
		  5'b00001    : Dout = Din1;
		  5'b00010    : Dout = Din2;
		  5'b00011    : Dout = Din3;
		  5'b00100    : Dout = Din4;
		  5'b00101    : Dout = Din5;
		  5'b00110    : Dout = Din6;
		  5'b00111    : Dout = Din7;
		  5'b01000    : Dout = Din8;
		  5'b01001    : Dout = Din9;
		  5'b01010    : Dout = Din10;
		  5'b01011    : Dout = Din11;
		  5'b01100    : Dout = Din12;
		  5'b01101    : Dout = Din13;
		  5'b01110    : Dout = Din14;
		  5'b01111    : Dout = Din15;
		  5'b10000    : Dout = Din16;
		  5'b10001    : Dout = Din17;
		  5'b10010    : Dout = Din18;
		  5'b10011    : Dout = Din19;
		  5'b10100    : Dout = Din20;
		  5'b10101    : Dout = Din21;
		  5'b10110    : Dout = Din22;
		  5'b10111    : Dout = Din23;
		  5'b11000    : Dout = Din24;
		  5'b11001    : Dout = Din25;
		  5'b11010    : Dout = Din26;
		  5'b11011    : Dout = Din27;
		  5'b11100    : Dout = Din28;
		  5'b11101    : Dout = Din29;
		  5'b11110    : Dout = Din30;
		  5'b11111    : Dout = Din31;
    endcase
end      
endmodule