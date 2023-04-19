//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: ROM Memory for instrucctions
// Date: 29/Nov/22
//////////////////////////////////////////////////////////////////////////////////
module Program_Memory
#
(
	parameter	MEMORY_DEPTH = 64,
	parameter	DATA_WIDTH = 32
)
(
	input 		[(DATA_WIDTH-1):0] 	Address,
	output reg 	[(DATA_WIDTH-1):0] 	Instruction
);

	reg 	[DATA_WIDTH-1:0] 	rom[MEMORY_DEPTH-1:0];

	initial begin
		//$readmemh("C:/My_Designs/QuartusPrime/MIPS_Multi_Cycle/Quartus_Project/program.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/riscv_multi_cycle/Riscv_Multi_Cycle/Quartus_Project/program.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/riscv_multi_cycle/Riscv_Multi_Cycle/Quartus_Project/program_hexa.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/riscv_multi_cycle/Riscv_Multi_Cycle/Quartus_Project/tarea_gpio.txt", rom);
		$readmemh("C:/My_Designs/QuartusPrime/riscv_multi_cycle/Riscv_Multi_Cycle/Quartus_Project/factorial_uart.txt", rom);
		//$readmemh("C:/My_Designs/QuartusPrime/riscv_multi_cycle/Riscv_Multi_Cycle/Quartus_Project/sll_slli_andi_and.txt", rom);
		
	end

	always @ (Address) begin
		//Instruction = rom[Address];
		 Instruction = rom[Address[31:2]];
	end
	
endmodule