//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: ROM Memory for instrucctions
// Date: 29/Nov/22
//////////////////////////////////////////////////////////////////////////////////
module Program_Memory
#
(
	parameter	MEMORY_DEPTH = 256,
	parameter	DATA_WIDTH = 32
)
(
	input 		[(DATA_WIDTH-1):0] 	Address,
	output reg 	[(DATA_WIDTH-1):0] 	Instruction
);

reg [DATA_WIDTH-1:0] rom[MEMORY_DEPTH-1:0];
	
wire [DATA_WIDTH-1:0] ADDRIn;

	
	
assign ADDRIn = Address - 32'h00400000;
	
	

	initial begin

		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/addi.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/matriz_x_vector.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/matriz_x_vector_2.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/store_test.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/matriz_x_vector_5.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/init_mem_2.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/nop.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/matriz_x_vector_6.txt", rom);
		
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/matriz_x_vector_7.txt", rom); //good one
		//$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/vxm_uart_2.txt", rom);
		$readmemh("C:/My_Designs/QuartusPrime/RISC_V_Pipeline/assembly_code/load_stall.txt", rom);
		
		
		
		
		
		
	end

	always @ (Address) begin
		//Instruction = rom[Address];
		// Instruction = rom[Address[31:2]];
		Instruction = rom[ADDRIn[31:2]];
	end
	
endmodule