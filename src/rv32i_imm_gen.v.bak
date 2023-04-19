module rv32i_imm_gen (
  input [6:0] opcode,
  input [2:0] funct3,
  
  input [6:0] funct7,
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] rd,
  input [11:0] imm_in,
  output reg [31:0] imm
);

  // Decode the instruction and generate the immediate value
  always @* begin
    case (opcode)
      7'h03: // LOAD instructions
        imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
      7'h13: // IMMEDIATE instructions
        case (funct3)
          3'b000: // ADDI
				 imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
          3'b010: // SLTI
             imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
          3'b011: // SLTIU
             imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
          3'b100: // XORI
             imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
          3'b110: // ORI
            imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
          3'b111: // ANDI
            imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
				
          3'b001: // SLLI
			   imm = { {27{imm_in[11]}} , {imm_in[4:0]} };
			 3'b101: // SRLI, SRAI_not_implemented
			   imm = { {27{imm_in[11]}} , {imm_in[4:0]} };
			 default:imm = 1; // Unsupported instruction
		 endcase

			 
                
				  
      7'h6F: // J-Type instructions
		  imm = {  {12{imm_in[11] }},  rs1[4:0]   , funct3[2:0] , imm_in[0], imm_in[10:1], 1'b0};
		  
		
		7'h63: // B-Type instructions 
		  //imm = {   {19{funct7[6]}} , rd[0], funct7[5:0], rd[4:1], 1'b0};
		    imm = {   {20{funct7[6]}} , rd[0], funct7[5:0], rd[4:1], 1'b0};
		  
		7'h23: // S-Type instructions 
		  imm = {  {20{funct7[6]}} ,funct7[6:0],rd[4:0] };
		7'h67: //JALR instruction
	     imm = { {20{imm_in[11] }} , {imm_in[11:0]} };
		  
		7'h33: //R-Type instructions
		  imm = { {16{1'b0}}, rs2[4:0], funct7[6:0] };
		  
		7'h17:  //U-Type instructions
		  imm = { funct7[6:0], rs2[4:0], rs1[4:0] , funct3[2:0], {12{1'b0}} };
		  

		default:imm = 1; // Unsupported instruction		 
 
                
    
    endcase
  end
 endmodule 