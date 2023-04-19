module RXshift_register(
 input clk,
 input rst,
 input en_start,
 input ser_bit,
 output [7:0]Sw
);

wire [10:0] shift_bits;
assign shift_bits[10] = ser_bit;
assign Sw = shift_bits[8:1];

genvar gi;

generate 
  for(gi = 0; gi<10; gi = gi +1) 
  begin:FF_
    FF_D_enable FF(
    .clk(clk),
    .rst(rst),
    .enable(en_start),
    .d(shift_bits[gi+1]),
    .q(shift_bits[gi]));
  end
endgenerate
endmodule