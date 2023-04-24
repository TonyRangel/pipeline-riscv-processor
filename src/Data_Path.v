///////////////////////////////////////////////
//Company: ITESO
//Engineer: Antonio Rangel Avila  
//Module Description: Data path, RISC-V 32bits m-cycle,parameterized;
//Date: April 24th 2023
///////////////////////////////////////////////
module Data_Path #(parameter DATA_WIDTH = 32)(
//INPUTS
input clk, reset, 

input FlushD, FlushE, StallD, StallE,



input [3:0] ALUControl, //Add base address to offset
input       RegWrite,   //Write Data to register file
input [1:0] ALUSrcA, 
input [1:0] ALUSrcB,    
input       MemWrite,      
input       MemRead,          
input [1:0] MemtoReg, 
input       Branch_sel,
input [1:0] Jump_sel,
input       Mux_IF_sel,



output Zero,
output wire [6:0] OpD,
output wire [2:0] Funct3D,
output wire [6:0] Funct7D,


output wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
output wire [4:0] RdE,

 




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
wire [DATA_WIDTH-1:0] rd1E, rd2E;


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


// Fetch Stage

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
								

// Instruction Fetch - Decode Pipeline Register	

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

							  
// Decode - Execute Pipeline Register
						  
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
													.RD1E(rd1E), 
													.RD2E(rd2E), 
													.PCE(pcE), 
													.Rs1E(Rs1E), 
													.Rs2E(Rs2E), 
													.RdE(RdE), 
													.ImmExtE(Sign_ImmE), 
													.PCPlus4E(PCPlus4E)
	                   );
						

					
//------------------------
//				EX
//------------------------		
							
							
							
Mux4x1 mux_b_input    ( 
													.Selector(ALUSrcB), 
													.I_0(), //rd2
													.I_1(Sign_Imm),
													.I_2(32'd4),
												   .I_3(0),	
													.Mux_Out(SrcB)
						     );
							 
ALU Alu  (
													.Control(ALUControl),
													.A(SrcA),
													.B(SrcB),
													.Result(ALUResult)
         );
			
ALU Adder_EX         (
													.Control(4'b0000),
													.A(), //adder_IF_res
													.B(),
													.Result()
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
								.ADDRIn(ALUResult),
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
								.Write_Data		(), //rd2						
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
							  

							  
													
		  

		  

						
							
//assign Op     = Instr[6:0];
//assign Funct3 = Instr[14:12];
//assign Funct7 = Instr[31:25];
//assign Zero = !ALUResult;

					
endmodule
