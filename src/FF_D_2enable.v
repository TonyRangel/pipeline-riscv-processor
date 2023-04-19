`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Cuauhtemoc Aguilera
//////////////////////////////////////////////////////////////////////////////////
module FF_D_2enable(
    input clk,
    input rst,
    input en0,
	 input en1,
    input d0,
	 input d1,
    output reg q
    );
always @(posedge rst, posedge clk) // asychronous reset
    begin
        if(rst)
            q <= 1'b1;
        else
            if(en0)
                q <= d0;
            else if (en1)
				    q <= d1;
				else
                q <= q;
end
endmodule