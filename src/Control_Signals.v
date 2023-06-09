/***
	Name: Main Decoder
	Description: This unit generates the control signals from the 7 bit opcode.
	Determines the type of instruction
***/

module control_signals(
	input   [6:0] op,
	input 	[2:0] Funct3,
	
	output  [1:0] ResultSrc,
	output        MemWrite,
	output        Branch, Branchn, ALUSrcA, 
	output  [1:0] ALUSrcB,
	output        RegWrite, Jump,
	output  [2:0] ImmSrc,
	output  [1:0] ALUOp
	);
	
localparam I_Type_LOAD    	= 7'h3;
localparam S_Type    		= 7'h23;
localparam R_Type    		= 7'h33;
localparam B_Type    		= 7'h63;
localparam I_Type_LOGIC    = 7'h13;
localparam J_JAL_Type    	= 7'h6F;
localparam U_AUIPC_Type    = 7'h17;
localparam U_LUI_type      = 7'h37;
localparam I_JALR_Type    	= 7'h67;
localparam value_reset    	= 7'h00;

reg [14:0] controls;


//always_comb
always@* begin
	case(op)
	// RegWrite_ImmSrc_ALUSrcA_ALUSrcB_MemWrite_ResultSrc_Branch_ALUOp_Jump
		I_Type_LOAD: 	controls = 15'b1_000_0_01_0_01_00_00_0; // lw
		S_Type: 			controls = 15'b0_001_0_01_1_00_00_00_0; // sw
		R_Type: 			controls = 15'b1_xxx_0_00_0_00_00_10_0; // R–type
		
		B_Type:
        case(Funct3)
		       3'b000:		 
					      controls = 15'b0_010_0_00_0_00_10_01_0; // BEQ-type
				 3'b001: 
				         controls = 15'b0_010_0_00_0_00_01_01_0; // BNQ-type
				 default: 
				         controls = 15'b0_000_0_00_0_00_00_00_0;
							endcase
		
		
		I_Type_LOGIC:  controls = 15'b1_000_0_01_0_00_00_10_0; // I–type ALU
		J_JAL_Type: 	controls = 15'b1_011_0_00_0_10_00_00_1; // jal
		U_AUIPC_Type:  controls = 15'b1_100_1_10_0_00_00_00_0; // auipc // PC Target for SrcB
		U_LUI_type: 	controls = 15'b1_100_1_01_0_00_00_00_0; // lui
		I_JALR_Type: 	controls = 15'b1_000_0_01_0_10_00_00_1; // jalr
		value_reset: 	controls = 15'b0_000_0_00_0_00_00_00_0; // for default values on reset
		
		default: 		controls = 15'b0_000_0_00_0_00_00_00_0; // instruction not implemented
	endcase
end
//assign {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc,Branch_n, Branch_q, ALUOp, Jump} = controls;

assign RegWrite 	= controls [14];	
assign ImmSrc 		= controls [13:11];
assign ALUSrcA 	= controls [10];
assign ALUSrcB		= controls [9:8];
assign  MemWrite 	= controls [7];
assign ResultSrc 	= controls [6:5];

assign Branch 	   = controls [4];
assign Branchn 	= controls [3];

assign ALUOp 		= controls [2:1];
assign Jump  		= controls [0];


endmodule