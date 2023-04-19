//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: arithmetic logic unit;parameterized;
// Date: 29/Nov/22
//////////////////////////////////////////////////////////////////////////////////
module ALU # (parameter DATA_WIDTH = 32)
(
	input			[3: 0]					Control,
	input			[DATA_WIDTH-1: 0]		A,
	input			[DATA_WIDTH-1: 0]		B,
	
	output reg 	[DATA_WIDTH-1: 0] 	Result
);

	
	always @ (*) begin
		Result = 32'b0;
		case (Control)
			4'b0000	:	Result = A + B;
			4'b0001	:	Result = A - B;
			4'b0010	:	Result = A * B;
			4'b0011	:	Result = A & B;
			4'b0100	:	Result = A | B;
			4'b0101	: 	Result = A ^ B;
			4'b0110	: 	Result = A << B;
			4'b0111	: 	Result = A >> B;
		    4'b1000	:	Result = (A < B) ? 32'd1 : 32'd0;
			
			default:		Result = 32'b0;
		endcase
	end
endmodule