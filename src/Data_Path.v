///////////////////////////////////////////////
//Company: ITESO
//Engineer: Antonio Rangel Avila  
//Module Description: Data path, RISC-V 32bits m-cycle,parameterized;
//Date: April 24th 2023
///////////////////////////////////////////////
module Data_Path #(parameter DATA_WIDTH = 32)(
//INPUTS
input clk, reset, 




input PCJalSrcE, PCSrcE, ALUSrcAE, 
input [1:0] ALUSrcBE,
input       RegWriteW,   
input [3:0] ALUControlE, 

input       MemWriteM,      
input       MemReadM,          
input [1:0] MemtoRegW, 
input       Branch_sel,
input       Mux_IF_sel,





output            ZeroE, SignE,
output wire [6:0] OpD,
output wire [2:0] Funct3D,
output wire [6:0] Funct7D,




input[1:0] ForwardAE, ForwardBE,
output wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
output wire [4:0] RdE, RdM, RdW,
input  StallD, StallF, FlushD, FlushE,


 




input  [7:0] gpio_port_in,   //GPIO Ports
output [7:0] gpio_port_out, //GPIO Ports

input uart_rx, 				//UART Ports
output uart_tx 				//UART Ports

);


//--------------------------------------------------
wire [DATA_WIDTH-1:0] adder_EX_res;
wire [DATA_WIDTH-1:0] pc_next, pcF, pcD, pcE, PCPlus4F, PCPlus4D, PCPlus4E;


wire [DATA_WIDTH-1:0] InstrF, InstrD;

wire [DATA_WIDTH-1:0] rd1D, rd2D, RdD;

wire [DATA_WIDTH-1:0] rd1E, rd2E, SrcAE, SrcBE, ALUResultE, PCTargetE, WriteDataE, SrcAEfor;

wire [DATA_WIDTH-1:0] ALUResultM, ReadDataM, WriteDataM, PCPlus4M; 

wire [DATA_WIDTH-1:0] ALUResultW, ReadDataW, PCPlus4W;

//wire [4:0] RdE, RdM, RdW;

wire [DATA_WIDTH-1:0] ResultW, BranJumpTargetE;






wire [6:0] OpE;
wire [2:0] Funct3E;
wire [6:0] Funct7E;





wire [DATA_WIDTH-1:0] ImmExtD, ImmExtE;




wire [DATA_WIDTH-1:0] Adr;





//wire [DATA_WIDTH-1:0] ALUOut;
//--------------------------------------------------

wire [DATA_WIDTH-1:0] Data;

wire [DATA_WIDTH-1:0] SrcA,SrcB;
wire [DATA_WIDTH-1:0] ALUResult;
wire [DATA_WIDTH-1:0] Sign_Imm;
wire [DATA_WIDTH-1:0] Shifted_Imm;
wire [DATA_WIDTH-1:0] Sign_Imm_shifted;


//--------------------------------------------------
wire RAMen, RAMen_r, GPIOen, UARTen;
wire [DATA_WIDTH-1:0] NADDR, FromMem, GPIOData, ROMDataOut, ram_out, UARTData;
wire [1:0] DataSel;
//--------------------------------------------------


//----- Fetch Stage
Mux2x1 jalr_mux ( 
													.Selector(PCJalSrcE), 
													.I_0(PCTargetE), 
													.I_1(ALUResultE), 
													.Mux_Out(BranJumpTargetE)
							 );

Mux2x1 IF_mux ( 
													.Selector(PCSrcE), 
													.I_0(PCPlus4F), 
													.I_1(BranJumpTargetE), 
													.Mux_Out(pc_next)
							 );



Reg_param  #
									(

												  .reset_value(32'h400000)
									) 
									Pc 
									(
												  .rst(reset), 
												  .clk(clk), 
												  .enable(~StallF),  //1'b1
												  .D(pc_next), 
												  .Q(pcF)
							      );

									
Program_Memory	ROM     (
												  .Address			(pcF),
												  .Instruction	(InstrF)
							  );
							  
							  
ALU Add_IF    (
													.Control(4'b0000),
													.A(pcF),
													.B(32'd4),
													.Result(PCPlus4F)
													
				  );
								
//----- Instruction Fetch - Decode Pipeline Register	

IF_ID pip_reg0 (
													.clk(clk),
													.reset(reset),
													.clear(FlushD),
													.enable(~StallD),
													.InstrF(InstrF),
													.PCF(pcF),
													.PCPlus4F(PCPlus4F),
													.InstrD(InstrD),
													.PCD(pcD),
													.PCPlus4D(PCPlus4D)
                );
					 
assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD = InstrD[11:7];

assign OpD     = InstrD[6:0];
assign Funct7D = InstrD[31:25];
assign Funct3D = InstrD[14:12];


				
						
						 
rv32i_imm_gen imm_gen  (
												  .opcode(InstrD[6:0]),
												  .funct3(InstrD[14:12]),
												  .rs1(InstrD[19:15]),
												  .rs2(InstrD[24:20]),
												  .rd(InstrD[11:7]),
												  .funct7(InstrD[31:25]),
												  .imm_in(InstrD[31:20]),
												  .imm(ImmExtD)
												 );
												 
//assign Sign_ImmD = Sign_Imm;
								
							
Reg_File Reg_file      (
													.A1(InstrD[19:15]),  
													.A2(InstrD[24:20]), 
													.A3(RdW),
												   .rst(reset), .clk(clk), 
											   	.WE3(RegWriteW), .WD3(ResultW),
													.RD1(rd1D), .RD2(rd2D)
                       );

							  
//----- Decode - Execute Pipeline Register
						  
ID_IEx pip_reg1       (
													.clk(clk), 
													.reset(reset), 
													.clear(FlushE),
													.RD1D(rd1D), 
													.RD2D(rd2D), 
													.PCD(pcD), 
													.Rs1D(Rs1D), 
													.Rs2D(Rs2D), 
													.RdD(RdD), 
													.ImmExtD(ImmExtD), 
													.PCPlus4D(PCPlus4D),
													.OpD(OpD),
												   .Funct7D(Funct7D),
												   .Funct3D(Funct3D),
													
													
													.RD1E(rd1E), 
													.RD2E(rd2E), 
													.PCE(pcE), 
													.Rs1E(Rs1E), 
													.Rs2E(Rs2E), 
													.RdE(RdE), 
													.ImmExtE(ImmExtE), 
													.PCPlus4E(PCPlus4E),
													
													.OpE(OpE),
											      .Funct7E(Funct7E),
											      .Funct3E(Funct3E)
	                   );
							 
Mux4x1 forwardMuxA (

                                       //.Selector(2'b00),//ForwardAE
													.Selector(ForwardAE),
													.I_0(rd1E),
													.I_1(ResultW),
													.I_2(ALUResultM),
													.I_3(32'b0),//no-use
													.Mux_Out(SrcAEfor)
                 
                   );
						

Mux2x1 srcamux    (
													.Selector(ALUSrcAE),
													.I_0(SrcAEfor),
													.I_1(32'b0),
													.Mux_Out(SrcAE)  // for lui
						    );
							 

							 
Mux4x1 forwardMuxB (

                                       //.Selector(2'b00),//ForwardEB
													.Selector(ForwardBE),
													.I_0(rd2E),
													.I_1(ResultW),
													.I_2(ALUResultM),
													.I_3(32'b0), // no-use
													.Mux_Out(WriteDataE)
                 
                   );
							 
Mux4x1 srcbmux    (
													.Selector(ALUSrcBE),
													.I_0(WriteDataE),
													.I_1(ImmExtE),
													.I_2(PCTargetE),
													.I_3(32'b0), //no-use
													.Mux_Out(SrcBE)
						    );
							 
ALU Adder_EX         (
													.Control(4'b0000),
													.A(pcE), 
													.B(ImmExtE),
													.Result(PCTargetE) // Next PC for jump and branch instruction
							);
							
alu2 Alu0            (
													
													.SrcA(SrcAE), 
													.SrcB(SrcBE), 
													.ALUControl(ALUControlE) , 
													.ALUResult(ALUResultE), 
													.Zero(ZeroE), .Sign(SignE)
                     );
							
					
//----- Execute - Memory Access Pipeline Register
							
							
IEx_IMem pipreg2     (

													.clk(clk), 
													.reset(reset),
													.ALUResultE(ALUResultE), 
													.WriteDataE(WriteDataE), 
													.RdE(RdE), 
													.PCPlus4E(PCPlus4E),
													.ALUResultM(ALUResultM), 
													.WriteDataM(WriteDataM),
													.RdM(RdM), 
													.PCPlus4M(PCPlus4M)
													
                    );
							 



Memory_Controller #
					(
								.DATA_WIDTH(32), .ADDR_WIDTH(32)
					) 
					MemCtrl
					(
								.WrtEn(MemWriteM),
								.RdEn(MemReadM),
								.ADDRIn(ALUResultM),
								.RAM_En(RAMen),
								.RAM_rd_En(RAMen_r),
								.GPIO_En(GPIOen),
								.UART_En(UARTen),
								.Sel(DataSel),
								.ADDROut(NADDR)
					);
					
Mux4x1 peripheral_mux ( 
								.Selector(DataSel), 
								.I_0(ram_out), 
								.I_1(UARTData), 
								.I_2(GPIOData), 
								.I_3(0), 
								.Mux_Out(ReadDataM)
							);
					
Data_Memory		RAM 	(
								.clk				(clk),
								.Write_Enable	(RAMen),
								.Read_Enable   (RAMen_r),
								.Write_Data		(WriteDataM), //rd2						
								.Address       (NADDR),
								.Read_Data		(ram_out)
							);
UART uart_0
							(
								.clk(clk),
								.rst(reset),
								.wrtEn(UARTen),
								.addr(NADDR[2]),
								.TxData(),//rd2
								.ReadReg(UARTData),
								.SerialOut(uart_tx),
								.SerialIn(uart_rx)
							);
							
GPIO gpio_0				(
								.clk(clk),
								.rst(reset),
								.en(GPIOen),
								.addr(NADDR[2]), 
								.PORT_IN(gpio_port_in),
								.DataToOut(),//rd2
								.PORT_OUT(gpio_port_out),
								.DataFromIn(GPIOData)
							); 

// Memory - Register Write Back Stage

IMem_IWB pipreg3     (
													.clk(clk), 
													.reset(reset),
													.ALUResultM(ALUResultM), 
													.ReadDataM(ReadDataM),  
													.RdM(RdM), 
													.PCPlus4M(PCPlus4M),
													
													.ALUResultW(ALUResultW), 
													.ReadDataW(ReadDataW),
													.RdW(RdW), 
													.PCPlus4W(PCPlus4W)
							);
			
			
//mux3 resultmux( ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);		  
Mux4x1 Write_data_mux ( 
													.Selector(MemtoRegW), 
													.I_0(ALUResultW), 
													.I_1(ReadDataW), 
													.I_2(PCPlus4W),
													.I_3(32'b0), //no-use
													.Mux_Out(ResultW)
							 );
							  

							  
													
		  

		  

						
							



					
endmodule
