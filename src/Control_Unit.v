//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: Control signals + ALU decoder integration;
// Date: 03/Mar/23
//////////////////////////////////////////////////////////////////////////////////
module Control_Unit
(
	input 			clk,
	input 			reset,
	
	//CONTROL SIGNALS
	input		[6:0]	Op,
	input 	[2:0] Funct3,
	input 	[6:0] Funct7,
	input				Zero,
	
	output   [1:0] JAL_o,
	output   [1:0] ALU_Src_a,
	output   [1:0] ALU_Src_b,
	output         Mem_to_Reg_o,
	output         Reg_Write_o,
	output         Mem_Read_o,
	output         Mem_Write_o,
	output         Branch_and_o,
	output   [3:0] ALU_Control
);


	//wire			PC_Write;
	wire			Branch_w, Branch_w_n;
	wire	[3:0]	ALU_Op;
	
	Control_Signals	State_and_Signals	(
										.clk(clk), 			
										.reset(reset),
										.OP_i(Op),
										.Funct3(Funct3),
										.Funct7(Funct7),
											
										.JAL_o(JAL_o),
										.ALU_Src_a(ALU_Src_a),
										.ALU_Src_b(ALU_Src_b),
										.Mem_to_Reg_o(Mem_to_Reg_o),
										.Reg_Write_o(Reg_Write_o),
										.Mem_Read_o(Mem_Read_o),
										.Mem_Write_o(Mem_Write_o),
										.Branch_o(Branch_w),
										.Branch_o_n(Branch_w_n),
										.ALU_OP_o(ALU_Op)
													
														
													);
	
	ALU_Decoder	Operation	(
										.ALU_Op			(ALU_Op),
										.Funct3			(Funct3),
										.Funct7        (Funct7),
										.ALU_Control	(ALU_Control)
									);
	
	assign Branch_and_o = (Branch_w & Zero) | (Branch_w_n & (!Zero) ) ;

	//= PC_Write | (Branch & Zero) | (Branch_n & (!Zero) )  ;
	
endmodule