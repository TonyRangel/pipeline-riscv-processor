//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: Data Path + Control unit integration
// Date: April/02/23
//////////////////////////////////////////////////////////////////////////////////
module RISC_V_Pipeline
(
	input 			clk,
	input 			reset,
	
	output clk_out,
	
	input		[7:0]	GPIO_in,    //GPIO Ports
	output	[7:0]	GPIO_out,

   input uart_rx, 				//UART Ports
   output uart_tx
);

	wire	[6:0]	Op_w;
	wire	[2:0] Funct3_w;
	wire	[6:0] Funct7_w;
	wire			Zero_w;
	

	wire 			Mem_Write_w;
	wire 			Mem_read_w;

	wire 	[1:0] Mem_to_Reg_w;
	wire 			Reg_Write_w;
	wire 	[1:0]	ALU_Src_A_w;
	wire	[1:0]	ALU_Src_B_w;
	wire 	[3:0]	ALU_Control_w;
	wire        Branch_sel_w;
	wire  [1:0] Jump_sel_w;

	assign clk_out = clk;
	
	
/*	Control_Unit	Control	(
					
									.clk				(clk),
									.reset			(reset),
									.Op				(Op_w),
									.Funct3			(Funct3_w),
									.Funct7			(Funct7_w),
									.Zero				(Zero_w),
									
									.JAL_o			(Jump_sel_w),
									.ALU_Src_a		(ALU_Src_A_w),
									.ALU_Src_b		(ALU_Src_B_w),
									.Mem_to_Reg_o	(Mem_to_Reg_w),
									.Reg_Write_o	(Reg_Write_w),
									.Mem_Read_o		(Mem_read_w),
									.Mem_Write_o	(Mem_Write_w),
									.Branch_and_o	(Branch_sel_w),
									.ALU_Control	(ALU_Control_w)

								); */
									
	
	Data_Path	#
					(
						.DATA_WIDTH(32)
					)
					DataPath	(
									.clk				(clk),
									.reset			(reset),
									
									.MemWrite		(Mem_Write_w),
									.MemRead       (Mem_read_w),
									.MemtoReg		(Mem_to_Reg_w),
									.Branch_sel    (Branch_sel_w),
									.Jump_sel      (Jump_sel_w),
									.RegWrite		(Reg_Write_w),
									.ALUSrcA       (ALU_Src_A_w),
									.ALUSrcB		   (ALU_Src_B_w),
									.ALUControlE	(ALU_Control_w),
									.ZeroM			(Zero_w),
									.OpD				(Op_w),
									.Funct3D			(Funct3_w),
									.Funct7D			(Funct7_w),
									.gpio_port_in  (GPIO_in),
									.gpio_port_out (GPIO_out),
									.uart_rx       (uart_rx), 
									.uart_tx       (uart_tx)  
									
									
									
								);


endmodule