module ALU_Decoder
(
	input 		[1:0]	ALU_Op,
	input 		[2:0]	Funct3,
	input       [6:0] Funct7,
	
	output reg	[3:0]	ALU_Control
);

/*	localparam	add 	= 8'b00_100000,
					addi	= 8'b00_xxxxxx,
					lui	= 8'b10_xxxxxx,
					andi   =8'b01_xxxxxx;*/
					
	localparam	add_d  = 12'b00_xxx_xxxxxxx,
	            add    = 12'b10_000_0000000,
	            addi   = 12'b11_000_xxxxxxx,
	
	            sub 	 = 12'b01_xxx_xxxxxxx,
					mul    = 12'b10_000_0000001,
					
					slti   = 12'b11_010_xxxxxxx,
					
					slli   = 12'b11_001_xxxxxxx,
					sll    = 12'b10_001_0000000,
					
					andi   = 12'b11_111_xxxxxxx,
					andd   = 12'b10_111_xxxxxxx;
					
					
					/*xorr   = 5'b00_100,
					sll    = 5'b00_101,
					srl    = 5'b01_101,
					orr    = 5'b00_110,
					andd   = 5'b00_111;*/
					
					
	
	
					/*addi	= 5'b00_,
					lui	= 5'b10_,
					andi   =5'b01_;*/
	
	
	always@({ALU_Op,Funct3, Funct7}) begin
		casex({ALU_Op,Funct3, Funct7})
		   add_d :  ALU_Control = 4'b0000;
			add	:	ALU_Control = 4'b0000;
			addi	:	ALU_Control = 4'b0000;
			
			sub	:	ALU_Control = 4'b0001;
			mul	:	ALU_Control = 4'b0010;
			
			andi	:	ALU_Control = 4'b0011;
			andd	:	ALU_Control = 4'b0011;
		/*	orr 	:	ALU_Control = 4'b0100;
			xorr   :	ALU_Control = 4'b0101;
			
			srl   :	ALU_Control = 4'b0111;*/
			slti   :	ALU_Control = 4'b1000;
			
			slli  :	ALU_Control = 4'b0110;
			sll   :	ALU_Control = 4'b0110;
			default: 	ALU_Control = 4'b0000; // Default case item
			

			/*addi	:	ALU_Control = 3'b000;
			
			andi	:	ALU_Control = 3'b011;
			
			lui	:	ALU_Control = 3'b110;*/

		endcase
	end
endmodule