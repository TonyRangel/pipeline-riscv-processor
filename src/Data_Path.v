///////////////////////////////////////////////
//Company: ITESO
//Engineer: Antonio Rangel Avila  
//Module Description: Data path, RISC-V 32bits multi-cycle,parameterized;
//Date: March 4th 2023
///////////////////////////////////////////////
module Data_Path #(parameter DATA_WIDTH = 32)(
//INPUTS
input clk, reset,

//CONTROL SIGNALS

input [3:0] ALUControl, //Add base address to offset

input       RegWrite,   //Write Data to register file
 
input [1:0] ALUSrcA, 
input [1:0] ALUSrcB,    
input       MemWrite,      
input       MemRead,          

input [1:0] MemtoReg, 
input       Branch_sel,
input [1:0] Jump_sel,



output Zero,
output [6:0] Op,
output [2:0] Funct3,
output [6:0] Funct7,

input [7:0] gpio_port_in,   //GPIO Ports
output [7:0] gpio_port_out, //GPIO Ports

input uart_rx, 				//UART Ports
output uart_tx 				//UART Ports

);

wire [DATA_WIDTH-1:0] pc, pc_next
//wire [DATA_WIDTH-1:0] ALUOut;
wire [DATA_WIDTH-1:0] Adr;
wire [DATA_WIDTH-1:0] Read_Data;


wire [DATA_WIDTH-1:0] Instr;

//--------------------------------------------------
wire [DATA_WIDTH-1:0] Write_Data;
wire [DATA_WIDTH-1:0] Data;
wire [DATA_WIDTH-1:0] rd1, rd2; //a, b;
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


//------------------------
//				IF
//------------------------
Mux2x1 IF_mux ( 
													.Selector(), 
													.I_0(), 
													.I_1(), 
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
												  .Q(pc)
							      );

									
Program_Memory	ROM     (
												  .Address			(pc),
												  .Instruction	(Instr)
							  );
							  
							  
ALU Add_IF    (
													.Control(4'b0000),
													.A(pc),
													.B(32'd4),
													.Result(pc4)
													
				  );
													

					
//------------------------
//				ID
//------------------------							

						 
rv32i_imm_gen imm_gen  (
												  .opcode(Instr[6:0]),
												  .funct3(Instr[14:12]),
												  .rs1(Instr[19:15]),
												  .rs2(Instr[24:20]),
												  .rd(Instr[11:7]),
												  .funct7(Instr[31:25]),
												  .imm_in(Instr[31:20]),
												  .imm(Sign_Imm)
												 );
								
							
Reg_File Reg_file      (
													.A1(Instr[19:15]),  
													.A2(Instr[24:20]), 
													.A3(Instr[11:7]),
												   .rst(reset), .clk(clk), 
											   	.WE3(RegWrite), .WD3(Write_Data),
													.RD1(rd1), .RD2(rd2)
                       );
						

					
//------------------------
//				EX
//------------------------		
							
							
							
Mux4x1 mux_b_input    ( 
													.Selector(ALUSrcB), 
													.I_0(rd2), 
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
													.A(pc),
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
								.Write_Data		(rd2),						
								.Address       (NADDR),
								.Read_Data		(ram_out)
							);
UART uart_0
							(
								.clk(clk),
								.rst(reset),
								.wrtEn(UARTen),
								.addr(NADDR[2]),
								.TxData(rd2),
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
								.DataToOut(rd2),
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
