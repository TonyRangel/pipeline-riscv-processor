module TXshift_register(
 input clk,
 input rst,
 input en_start,
 input en_shift,
 input [9:0]Sw,
 output ser_bit
);

wire [10:0] shift_bits;
assign shift_bits[0] = 1'b1;
assign ser_bit = shift_bits[10];

genvar gi;

generate 
  for(gi = 0; gi<10; gi = gi +1) 
  begin:FF_
    FF_D_2enable FF(
    .clk(clk),
    .rst(rst),
    .en0(en_start),
    .en1(en_shift),
    .d0(Sw[9-gi]),
    .d1(shift_bits[gi]),
    .q(shift_bits[gi+1]));
  end
endgenerate
endmodule