//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Antonio Rangel Avila
// Description : Register File RTL module for mulcycle MIPs
//////////////////////////////////////////////////////////////////////////////////

module Reg_File # (parameter ADDR_WIDTH=5, parameter DATA_WIDTH=32)
	(
	input [ADDR_WIDTH-1:0] A1, A2, A3,
	input rst, clk,
	input WE3, 
	input [DATA_WIDTH-1:0] WD3, 
	output [DATA_WIDTH-1:0]RD1, RD2
	);
	
wire [DATA_WIDTH-1:0] q [DATA_WIDTH-1:0];
wire [DATA_WIDTH-1:0] one_hot;

Decoder_Onehot dec (.Write_Register(A3), .one_hot(one_hot) );

Reg_param zero (.rst(rst), .clk(clk), .enable(one_hot[0]  & WE3 ), .D(0),   .Q(q[0]));
Reg_param ra   (.rst(rst), .clk(clk), .enable(one_hot[1]  & WE3 ), .D(WD3), .Q(q[1]));
Reg_param #(.reset_value(32'h7fffeffc)) sp   (.rst(rst), .clk(clk), .enable(one_hot[2]  & WE3),  .D(WD3), .Q(q[2]));
Reg_param gp   (.rst(rst), .clk(clk), .enable(one_hot[3]  & WE3),  .D(WD3), .Q(q[3]));
Reg_param tp   (.rst(rst), .clk(clk), .enable(one_hot[4]  & WE3),  .D(WD3), .Q(q[4]));
Reg_param t0   (.rst(rst), .clk(clk), .enable(one_hot[5]  & WE3),  .D(WD3), .Q(q[5]));
Reg_param t1   (.rst(rst), .clk(clk), .enable(one_hot[6]  & WE3),  .D(WD3), .Q(q[6]));
Reg_param t2   (.rst(rst), .clk(clk), .enable(one_hot[7]  & WE3),  .D(WD3), .Q(q[7]));
Reg_param s0   (.rst(rst), .clk(clk), .enable(one_hot[8]  & WE3),  .D(WD3), .Q(q[8]));
Reg_param s1   (.rst(rst), .clk(clk), .enable(one_hot[9]  & WE3),  .D(WD3), .Q(q[9]));
Reg_param a0   (.rst(rst), .clk(clk), .enable(one_hot[10] & WE3), .D(WD3), .Q(q[10]));
Reg_param a1   (.rst(rst), .clk(clk), .enable(one_hot[11] & WE3), .D(WD3), .Q(q[11]));
Reg_param a2   (.rst(rst), .clk(clk), .enable(one_hot[12] & WE3), .D(WD3), .Q(q[12]));
Reg_param a3   (.rst(rst), .clk(clk), .enable(one_hot[13] & WE3), .D(WD3), .Q(q[13]));
Reg_param a4   (.rst(rst), .clk(clk), .enable(one_hot[14] & WE3), .D(WD3), .Q(q[14]));
Reg_param a5   (.rst(rst), .clk(clk), .enable(one_hot[15] & WE3), .D(WD3), .Q(q[15]));
Reg_param a6   (.rst(rst), .clk(clk), .enable(one_hot[16] & WE3), .D(WD3), .Q(q[16]));
Reg_param a7   (.rst(rst), .clk(clk), .enable(one_hot[17] & WE3), .D(WD3), .Q(q[17]));
Reg_param s2   (.rst(rst), .clk(clk), .enable(one_hot[18] & WE3), .D(WD3), .Q(q[18]));
Reg_param s3   (.rst(rst), .clk(clk), .enable(one_hot[19] & WE3), .D(WD3), .Q(q[19]));
Reg_param s4   (.rst(rst), .clk(clk), .enable(one_hot[20] & WE3), .D(WD3), .Q(q[20]));
Reg_param s5   (.rst(rst), .clk(clk), .enable(one_hot[21] & WE3), .D(WD3), .Q(q[21]));
Reg_param s6   (.rst(rst), .clk(clk), .enable(one_hot[22] & WE3), .D(WD3), .Q(q[22]));
Reg_param s7   (.rst(rst), .clk(clk), .enable(one_hot[23] & WE3), .D(WD3), .Q(q[23]));
Reg_param s8   (.rst(rst), .clk(clk), .enable(one_hot[24] & WE3), .D(WD3), .Q(q[24]));
Reg_param s9   (.rst(rst), .clk(clk), .enable(one_hot[25] & WE3), .D(WD3), .Q(q[25]));
Reg_param s10   (.rst(rst), .clk(clk), .enable(one_hot[26] & WE3), .D(WD3), .Q(q[26]));
Reg_param s11   (.rst(rst), .clk(clk), .enable(one_hot[27] & WE3), .D(WD3), .Q(q[27]));
Reg_param t3   (.rst(rst), .clk(clk), .enable(one_hot[28] & WE3), .D(WD3), .Q(q[28]));
Reg_param t4   (.rst(rst), .clk(clk), .enable(one_hot[29] & WE3), .D(WD3), .Q(q[29]));
Reg_param t5   (.rst(rst), .clk(clk), .enable(one_hot[30] & WE3), .D(WD3), .Q(q[30]));
Reg_param t6   (.rst(rst), .clk(clk), .enable(one_hot[31] & WE3), .D(WD3), .Q(q[31]));


Mux Mux1to32_1 (
						  .Sel(A1),

						  .Din0(q[0]), 
						  .Din1(q[1]),
						  .Din2(q[2]),
						  .Din3(q[3]),
						  .Din4(q[4]),
						  .Din5(q[5]),
						  .Din6(q[6]),
						  .Din7(q[7]),
						  .Din8(q[8]),
						  .Din9(q[9]),
						  .Din10(q[10]),
						  .Din11(q[11]),
						  .Din12(q[12]),
						  .Din13(q[13]),
						  .Din14(q[14]),
						  .Din15(q[15]),
						  .Din16(q[16]),
						  .Din17(q[17]),
						  .Din18(q[18]),
						  .Din19(q[19]),
						  .Din20(q[20]),
						  .Din21(q[21]),
						  .Din22(q[22]),
						  .Din23(q[23]),
						  .Din24(q[24]),
						  .Din25(q[25]),
						  .Din26(q[26]),
						  .Din27(q[27]),
						  .Din28(q[28]),
						  .Din29(q[29]),
						  .Din30(q[30]),
						  .Din31(q[31]),

						  .Dout(RD1) 

					);
					
Mux Mux1to32_2 (
						  .Sel(A2),

						  .Din0(q[0]), 
						  .Din1(q[1]),
						  .Din2(q[2]),
						  .Din3(q[3]),
						  .Din4(q[4]),
						  .Din5(q[5]),
						  .Din6(q[6]),
						  .Din7(q[7]),
						  .Din8(q[8]),
						  .Din9(q[9]),
						  .Din10(q[10]),
						  .Din11(q[11]),
						  .Din12(q[12]),
						  .Din13(q[13]),
						  .Din14(q[14]),
						  .Din15(q[15]),
						  .Din16(q[16]),
						  .Din17(q[17]),
						  .Din18(q[18]),
						  .Din19(q[19]),
						  .Din20(q[20]),
						  .Din21(q[21]),
						  .Din22(q[22]),
						  .Din23(q[23]),
						  .Din24(q[24]),
						  .Din25(q[25]),
						  .Din26(q[26]),
						  .Din27(q[27]),
						  .Din28(q[28]),
						  .Din29(q[29]),
						  .Din30(q[30]),
						  .Din31(q[31]),

						  .Dout(RD2) 

					);



endmodule
