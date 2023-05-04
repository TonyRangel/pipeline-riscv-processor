/*
	Name: Pipeline register between Datapath Decode and Execution Stage
	
*/


module ID_IEx  (
    input         clk, reset, clear,
    input  [31:0] RD1D, RD2D, PCD, 
    input  [4:0]  Rs1D, Rs2D, RdD, 
    input  [31:0] ImmExtD, PCPlus4D,
	 
	 input [6:0] OpD,
	 input [6:0] Funct7D,
	 input [2:0] Funct3D,
	 
    output reg [31:0] RD1E, RD2E, PCE, 
    output reg [4:0]  Rs1E, Rs2E, RdE, 
    output reg [31:0] ImmExtE, PCPlus4E,
	 
	 output reg [6:0] OpE,
	 output reg [6:0] Funct7E,
	 output reg [2:0] Funct3E
	 
	 );
	 

	 

    always @( negedge clk, posedge reset ) begin
        if (reset) begin
            RD1E <= 0;
            RD2E <= 0;
            PCE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            ImmExtE <= 0;
            PCPlus4E <= 0;
				OpE <= 0;
				Funct7E <= 0;
				Funct3E <= 0;
        end

        else if (clear) begin
            RD1E <= 0;
            RD2E <= 0;
            PCE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            ImmExtE <= 0;
            PCPlus4E <= 0;
				OpE <= 0;
				Funct7E <= 0;
				Funct3E <= 0;
        end
        else begin
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;
				OpE <= OpD;
				Funct7E <= Funct7D;
				Funct3E <= Funct3D ;
        end

    end

endmodule