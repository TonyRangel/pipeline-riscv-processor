module ALU_Decoder
(
	input 		[2:0]	ALU_Op,
	input 		[2:0]	Funct3,
	input       [6:0] Funct7,
	
	output reg	[3:0]	ALU_Control
);


					
	localparam	add_d  = 14'b0000_xxx_xxxxxxx,
	            add    = 14'b0010_000_0000000,
	            addi   = 14'b0011_000_xxxxxxx,
	
	            sub 	 = 14'b0001_xxx_xxxxxxx,
					mul    = 14'b0010_000_0000001,
					
					slti   = 14'b0011_010_xxxxxxx,
					
					slli   = 14'b0011_001_xxxxxxx,
					sll    = 14'b0010_001_0000000,
					
					andi   = 14'b0011_111_xxxxxxx,
					andd   = 14'b0010_111_xxxxxxx;
					
					

	
	always@({ALU_Op,Funct3, Funct7}) begin
		casex({ALU_Op,Funct3, Funct7})
		   add_d :  ALU_Control = 4'b0000;
			add	:	ALU_Control = 4'b0000;
			addi	:	ALU_Control = 4'b0000;
			
			sub	:	ALU_Control = 4'b0001;
			mul	:	ALU_Control = 4'b0010;
			
			andi	:	ALU_Control = 4'b0011;
			andd	:	ALU_Control = 4'b0011;

			slti   :	ALU_Control = 4'b1000;
			
			slli  :	ALU_Control = 4'b0110;
			sll   :	ALU_Control = 4'b0110;
			default: 	ALU_Control = 4'b0000; // Default case item
			


		endcase
	end
endmodule