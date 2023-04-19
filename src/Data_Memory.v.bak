//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: RAM memory for data
// Date: 29/Nov/22
//////////////////////////////////////////////////////////////////////////////////
module Data_Memory
#
(
	parameter	MEMORY_DEPTH = 64,
	parameter 	DATA_WIDTH = 32
)
(
	input 								clk,
	input 								Write_Enable,
	input 	[(DATA_WIDTH-1):0]	Write_Data,
	input		[(DATA_WIDTH-1):0] 	Address,
	
	output	[(DATA_WIDTH-1):0] 	Read_Data
);

	reg 	[DATA_WIDTH-1:0] 	ram[MEMORY_DEPTH-1:0];
	reg 	[DATA_WIDTH-1:0] 	Address_reg;
	
	wire  [(DATA_WIDTH-3):0] CurrAddr;
   assign CurrAddr=Address[(DATA_WIDTH-1):2]; 
	
	always @ (posedge clk) begin
		if (Write_Enable) //begin
			//ram[Address] <= Write_Data;
			ram[CurrAddr] <= Write_Data;
			  
		end
		//Address_reg <= Address;
	//end

	//assign Read_Data = ram[Address_reg];
assign Read_Data = ram[CurrAddr];

endmodule