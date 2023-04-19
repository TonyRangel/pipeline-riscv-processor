//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: Functional model of a parametric register
// with asynchronous reset.
//////////////////////////////////////////////////////////////////////////////////
module Reg_param #(
parameter width=32,
parameter reset_value = 0
) 
(
input rst, clk, enable,
input [width-1:0]D,
output reg [width-1:0]Q);

//always@(posedge rst, posedge clk) begin
always@(negedge rst, posedge clk) begin
    if(!rst)
		    Q  <= reset_value;
	 else if(enable)
		      Q <= D;
			else
			   Q <= Q;
	end
endmodule