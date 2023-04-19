`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Cuauhtemoc Aguilera & Edgar Barba & Jorge Velazquez 
// Bit rate pulse generator for a Serial RS-232 Receiver
//////////////////////////////////////////////////////////////////////////////////
module Bit_Rate_Pulse
 # (parameter delay_counts = 11 ) 
    (input clk,
    input rst,
    input enable,
    output end_bit_time
    );
//Variable to defined total count for delay of 106us  
 
 reg [12:0]count ;  
    // Comparator
assign end_bit_time = (delay_counts - 1'b1 ==count)?1'b1:1'b0;
// Counter
always @(posedge rst, posedge clk)
    begin
        if (rst)
            count <= 13'b0;
        else 
            if (enable)
                if (end_bit_time)
                         count <= 13'b0;
                else 
                        count <= count + 13'b1;
             else
                count <= count;
     end
endmodule