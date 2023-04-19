module shift_left_one(

input [31:0] in, 
output reg [31:0] out

);

always @(*) begin
    out = {in[30:0], 1'b0};
end

endmodule