///////////////////////////////////////////////
//Company: ITESO
//Engineer: Antonio Rangel Avila  
//Module Description: Data path, RISC-V 32bits m-cycle,parameterized;
//Date: April 24th 2023
///////////////////////////////////////////////
module Data_Path #(parameter DATA_WIDTH = 32)(
//INPUTS
input clk, reset, 


input [3:0] ALUControlE, 

input       RegWrite,   
input [1:0] ALUSrcA, 
input [1:0] ALUSrcB,    
input       MemWrite,      
input       MemRead,          
input [1:0] MemtoReg, 
input       Branch_sel,
input [1:0] Jump_sel,
input       Mux_IF_sel,

input       FlushD, FlushE, StallD, StallE,
input [1:0] ForwardAE, ForwardBE,




output wire       ZeroM,
output wire [6:0] OpD,
output wire [2:0] Funct3D,
output wire [6:0] Funct7D,


output wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E,


//output wire [4:0] RdE,


 




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

wire [DATA_WIDTH-1:0] rd1E, rd2E, SrcAE, SrcBE, ALUResultE, PCTargetE, WriteDataE;

wire [DATA_WIDTH-1:0] ALUResultM, WriteDataM, PCPlus4M; 

wire [4:0] RdE, RdM;

wire ZeroE;


wire [6:0] OpE;
wire [2:0] Funct3E;
wire [6:0] Funct7E;

wire 						 ALUSrcAE;
wire [1:0]  		    ALUSrcBE;


wire [DATA_WIDTH-1:0] Sign_ImmD, Sign_ImmE;




wire [DATA_WIDTH-1:0] Adr;
wire [DATA_WIDTH-1:0] Read_Data;




//wire [DATA_WIDTH-1:0] ALUOut;
//--------------------------------------------------
wire [DATA_WIDTH-1:0] Write_Data;
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

Mux2x1 IF_mux ( 
													.Selector(Mux_IF_sel), 
													.I_0(PCPlus4F), 
													.I_1(adder_EX_res), 
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
												  .enable(1'b1), 
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
													.enable(StallD),
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
												  .imm(Sign_Imm)
												 );
												 
assign Sign_ImmD = Sign_Imm;
								
							
Reg_File Reg_file      (
													.A1(InstrD[19:15]),  
													.A2(InstrD[24:20]), 
													.A3(InstrD[11:7]),
												   .rst(reset), .clk(clk), 
											   	.WE3(RegWrite), .WD3(Write_Data),
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
													.ImmExtD(Sign_ImmD), 
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
													.ImmExtE(Sign_ImmE), 
													.PCPlus4E(PCPlus4E),
													
													.OpE(OpE),
											      .Funct7E(Funct7E),
											      .Funct3E(Funct3E)
	                   );
							 
Mux4x1 forwardMuxA (

                                       .Selector(ForwardAE),
													.I_0(rd1E),
													.I_1(32'b0),
													.I_2(32'b0),
													.I_3(32'b0),
													.Mux_Out(SrcAEfor)
                 
                   );
						

Mux2x1 srcamux    (
													.Selector(ALUSrcAE),
													.I_0(SrcAEfor),
													.I_1(32'b0),
													.Mux_Out(SrcAE)  // for lui
						    );
							 

							 
Mux4x1 forwardMuxB (

                                       .Selector(ForwardBE),
													.I_0(Rs2E),
													.I_1(32'b0),
													.I_2(32'b0),
													.I_3(32'b0),
													.Mux_Out(WriteDataE)
                 
                   );
							 
Mux4x1 srcbmux    (
													.Selector(ALUSrcBE),
													.I_0(WriteDataE),
													.I_1(32'b0),
													.I_2(32'b0),
													.I_3(32'b0),
													.Mux_Out(SrcBE)
						    );
							 
ALU Adder_EX         (
													.Control(4'b0000),
													.A(pcE), 
													.B(Sign_ImmE),
													.Result(PCTargetE) // Next PC for jump and branch instruction
							);
							
ALU Alu              (
													.Control(ALUControlE),
													.A(SrcAE),
													.B(SrcBE),
													.Result(ALUResultE)
                     );
							
assign ZeroE = !ALUResultE;
					
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
							 

			

							 
//------------------------
//				MEM
//------------------------		

Memory_Controller #
					(
								.DATA_WIDTH(32), .ADDR_WIDTH(32)
					) 
					MemCtrl
					(
								.WrtEn(MemWrite),
								.RdEn(MemRead),
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
								.Mux_Out(Read_Data)
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


//------------------------
//				WB
//------------------------	
			
			
		  
Mux2x1 Write_data_mux ( 
													.Selector(MemtoReg), 
													.I_0(ALUResult), 
													.I_1(Read_Data), 
													.Mux_Out(Write_Data)
							 );
							  

							  
													
		  

		  

						
							



					
endmodule
