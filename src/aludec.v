/*
	Name: ALU Decoder
	Description: Receives control signal from the Main Decoder Unit and 
	determines the type of operation that has to be performed by the ALU
*/



module aludec(
input       opb5,
input  [2:0] funct3,
input        funct7b5, funct7b1,
input  [1:0] ALUOp,

output reg [3:0] ALUControl);
	
wire RtypeSub, RtypeMul;

assign RtypeSub = funct7b5 & opb5; // TRUE for R-type subtract
assign RtypeMul = funct7b1 & opb5 & (~funct7b5); // TRUE for R-type mul

always @ * begin
	case(ALUOp)
		2'b00: ALUControl = 4'b0000; // addition
		2'b01: ALUControl = 4'b0001; // subtraction
		default: case(funct3) // R–type or I–type ALU
			3'b000: 
			   if (RtypeSub) begin
				ALUControl = 4'b0001;end  // sub
				else if (RtypeMul) begin
				ALUControl = 4'b0110;end // MUL
			else
				ALUControl = 4'b0000;// add, addi
				
			3'b001: ALUControl = 4'b0100; // sll, slli
			3'b010: ALUControl = 4'b0101; // slt, slti
			3'b011: ALUControl = 4'b1000; // sltu, sltiu
			//3'b100: ALUControl = 4'b0110; // xor, xori
			
			3'b101: if (~funct7b5)
				ALUControl = 4'b0111;	// srl
			else
				ALUControl = 4'b1111;  // sra
			3'b110: ALUControl = 4'b0011; // or, ori
			3'b111: ALUControl = 4'b0010; // and, andi
			default: ALUControl = 4'bxxxx; // ???
			
			endcase
	endcase
end
endmodule
