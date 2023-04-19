//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer:  Antonio Rangel Avila
// Description: FSM states definition;
// Date: April/02/23
//////////////////////////////////////////////////////////////////////////////////
module Control_Signals
(
	input 			clk,
	input 			reset,
	
	input		[6:0]	OP_i,
	input 	[2:0] Funct3,
	input 	[6:0] Funct7,
		
	
	output   [1:0] JAL_o,
	output   [1:0] ALU_Src_a,
	output   [1:0] ALU_Src_b,
	output         Mem_to_Reg_o,
	output         Reg_Write_o,
	output         Mem_Read_o,
	output         Mem_Write_o,
	output         Branch_o,
	output         Branch_o_n,
	output   [3:0] ALU_OP_o
);

localparam R_Type    		= 7'h33;
localparam I_Type_LOGIC    = 7'h13;
localparam U_LUI_type      = 7'h34;
localparam U_AUIPC_Type    = 7'h17;

localparam B_Type    		= 7'h63;
//localparam B_Type_n    		= 7'h63;

localparam I_Type_LOAD    	= 7'h3;
localparam S_Type    		= 7'h23;
localparam J_JAL_Type    	= 7'h6F;
localparam I_JALR_Type    	= 7'h67;

/*localparam R_Type    		= 10'b0110011_xxx,
			  I_Type_LOGIC    = 10'b0010011_xxx,
			  U_LUI_type      = 10'b0110100_xxx,
			  U_AUIPC_Type    = 10'b0010111_xxx,

			  B_Type    		= 10'b1100011_000,
			  B_Type_n    		= 10'b1100011_001,

 I_Type_LOAD    	= 10'b0000011_xxx,
 S_Type    		= 10'b0100011_xxx,
 J_JAL_Type    	= 10'b1101111_xxx,
 I_JALR_Type    	= 10'b1100111_xxx;*/


reg [15:0] control_values;

//always@(OP_i) begin
always@* begin
	 case(OP_i)
	     R_Type:  			control_values = 16'b00_00_00_0_1_0_0_0_0_0010;
		  
		  I_Type_LOAD:    control_values = 16'b00_00_01_1_1_1_0_0_0_0000;
		  I_Type_LOGIC:   control_values = 16'b00_00_01_0_1_0_0_0_0_0011;
		  
		  
		  B_Type:        
		                 case(Funct3) 
							      3'b000:
		                         control_values = 16'b00_00_00_0_0_0_0_1_0_0001;
									3'b001:
									    control_values = 16'b00_00_00_0_0_0_0_0_1_0001;
								default: 
	                            control_values = 16'b00_00_00_0_0_0_0_0_0_0000;
								endcase
								
				
		  
		  S_Type:         control_values = 16'b00_00_01_0_0_0_1_0_0_0000;
		  
		  U_AUIPC_Type:   control_values = 16'b00_01_01_0_1_0_0_0_0_0000;
		  U_LUI_type:     control_values = 16'b00_10_01_0_1_0_0_0_0_0000;

		  J_JAL_Type:    control_values  = 16'b01_01_10_0_1_0_0_0_0_0000;
		  
		  
		  I_JALR_Type:    control_values = 16'b10_01_10_0_1_0_0_0_0_0000;
		  
		  
	 default: 
	         control_values = 16'b00_00_00_0_0_0_0_0_0_0000; 
					 
	 endcase
end



/*assign JAL_o = control_values[14:13];
assign ALU_Src_a = control_values[12:11];
assign ALU_Src_b = control_values[10:9];
assign Mem_to_Reg_o = control_values[8];
assign Reg_Write_o = control_values[7];
assign Mem_Read_o = control_values[6];
assign Mem_Write_o = control_values[5];
assign Branch_o = control_values[4];
assign ALU_OP_o = control_values[3:0]; */

assign JAL_o = control_values[15:14];
assign ALU_Src_a = control_values[13:12];
assign ALU_Src_b = control_values[11:10];
assign Mem_to_Reg_o = control_values[9];
assign Reg_Write_o = control_values[8];
assign Mem_Read_o = control_values[7];
assign Mem_Write_o = control_values[6];
assign Branch_o = control_values[5];
assign Branch_o_n = control_values[4];
assign ALU_OP_o = control_values[3:0];

endmodule


	 



