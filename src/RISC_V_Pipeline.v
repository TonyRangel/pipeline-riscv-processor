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
	wire			Zero_w, Sign_w ;
	

	wire 			Mem_Write_w;
	wire 			Mem_read_w;

	wire 	[1:0] Mem_to_Reg_w;
	wire 			RegWriteM, RegWriteW;

	wire 	[3:0]	ALUControlE;
	wire        Branch_sel_w;
	wire  [1:0] Jump_sel_w;
	wire         StallD, StallF, FlushD, FlushE, ResultSrcE0; //ResultSrcE0_w,
	wire        PCJalSrcE, PCSrcE, ALUSrcAE;
	wire  [1:0] ALUSrcBE;
	
	wire  [4:0] Rs1D, Rs2D, Rs1E, Rs2E;
   wire  [4:0] RdE, RdM, RdW;
	
	wire [1:0] ForwardAE, ForwardBE;
	

	assign clk_out = clk;
	
	
	

//controller c(clk, reset, InstrD[6:0], InstrD[14:12], InstrD[30], ZeroE, SignE, FlushE, ResultSrcE0, ResultSrcW, 
//MemWriteM, PCJalSrcE, PCSrcE, ALUSrcAE, ALUSrcBE, RegWriteM, RegWriteW, ImmSrcD, ALUControlE);

								
 controller control(
									.clk(clk), .reset(reset),
									.op(Op_w),
									.funct3(Funct3_w),
									.funct7b5(Funct7_w[5]),
									.ZeroE(Zero_w),
									.SignE(Sign_w),
									.FlushE(FlushE),

									.ResultSrcE0(ResultSrcE0), //hazard unit
									.ResultSrcW(Mem_to_Reg_w),
									.MemWriteM(Mem_Write_w),
									.PCJalSrcE(PCJalSrcE), .PCSrcE(PCSrcE), .ALUSrcAE(ALUSrcAE), 
									.ALUSrcBE(ALUSrcBE),
									.RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
									.ImmSrcD(),
									.ALUControlE(ALUControlE)
									
);

//hazardunit h (Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW, RegWriteM, RegWriteW, ResultSrcE0, PCSrcE, ForwardAE, ForwardBE, StallD, StallF, FlushD, FlushE);
   hazardunit h (
									.Rs1D(Rs1D), .Rs2D(Rs2D), .Rs1E(Rs1E), .Rs2E(Rs2E),
									.RdE(RdE), .RdM(RdM), .RdW(RdW),
									.RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
									.ResultSrcE0(ResultSrcE0), .PCSrcE(PCSrcE),

									.ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
									.StallD(StallD), .StallF(StallF), .FlushD(FlushD), .FlushE(FlushE)
	             );
									
//datapath dp(clk, reset, ResultSrcW, PCJalSrcE, PCSrcE,ALUSrcAE, ALUSrcBE, RegWriteW, ImmSrcD, ALUControlE, ZeroE, SignE, 
//PCF, InstrF, InstrD, ALUResultM, WriteDataM, ReadDataM, ForwardAE, ForwardBE, Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW, 
//StallD, StallF, FlushD, FlushE);



	Data_Path	#
					(
						.DATA_WIDTH(32)
					)
					DataPath	(
									.clk				(clk),
									.reset			(reset),
									//.FlushD        (FlushD), //1'b0
									//.StallD        (StallD), //1'b1
									
									
									.MemWriteM		(Mem_Write_w),
									.MemReadM      (Mem_read_w),
									.MemtoRegW		(Mem_to_Reg_w),
									
									.Branch_sel    (Branch_sel_w),
									.RegWriteW		(RegWriteW),
									.ALUSrcAE      (ALUSrcAE),
									.ALUSrcBE		(ALUSrcBE),
									.ALUControlE	(ALUControlE),
									.OpD				(Op_w),
									.Funct3D			(Funct3_w),
									.Funct7D			(Funct7_w),
									.ZeroE			(Zero_w),
							      .SignE			(Sign_w),
									
									//.FlushE			(FlushE), //1'b0
									.PCJalSrcE		(PCJalSrcE), 
									.PCSrcE			(PCSrcE),
									
									.ForwardAE(ForwardAE), .ForwardBE(ForwardBE), 
									.Rs1D(Rs1D), .Rs2D(Rs2D), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE), .RdM(RdM), .RdW(RdW), 
                           .StallD(StallD), .StallF(StallF) , .FlushD(FlushD), .FlushE(FlushE),
								   
									
									
									
									.gpio_port_in  (GPIO_in),
									.gpio_port_out (GPIO_out),
									.uart_rx       (uart_rx), 
									.uart_tx       (uart_tx)  
									
									
									
								);


endmodule