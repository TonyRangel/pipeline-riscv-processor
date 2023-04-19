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
	
	output  			PC_En,
	output			I_or_D,
	output 			Mem_Write,
	output 			IR_Write,
	output 	[1:0]	Mem_to_Reg,
	output 			Reg_Write,
	output 	[1:0]	ALU_Src_A,
	output 	[1:0]	ALU_Src_B,
	output 	[3:0]	ALU_Control,
	output 	[1:0]	PC_Src
	//new for risc-v implementaion
	//output          PCWriteCond,
	//output          PCWriteCond_n,
	
);
	
	wire			PC_Write;
	wire			Branch, Branch_n;
	wire	[1:0]	ALU_Op;
	
	Control_Signals	State_and_Signals	(
														.clk			(clk),
														.reset		(reset),
														.Op			(Op),
														.Funct3		(Funct3),
														.Funct7		(Funct7),
														.PC_Write	(PC_Write),
														.I_or_D		(I_or_D),
														.Mem_Write	(Mem_Write),
														.IR_Write	(IR_Write),
														.Mem_to_Reg	(Mem_to_Reg),
														.Reg_Write	(Reg_Write),
														.ALU_Src_A	(ALU_Src_A),
														.ALU_Src_B	(ALU_Src_B),
														.ALU_Op		(ALU_Op),
														.PC_Src		(PC_Src),
														.Branch_n	(Branch_n),
														.Branch		(Branch)
													);
	
	ALU_Decoder	Operation	(
										.ALU_Op			(ALU_Op),
										.Funct3			(Funct3),
										.Funct7        (Funct7),
										.ALU_Control	(ALU_Control)
									);
	
	assign PC_En = PC_Write | (Branch & Zero) | (Branch_n & (!Zero) )  ;
	
endmodule