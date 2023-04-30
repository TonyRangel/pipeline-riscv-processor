/*
	Name: Pipeline register between Datapath Execution and Memory Access Stage
*/


module IEx_IMem(

input  clk, reset,
input      [31:0] ALUResultE, WriteDataE, 
input      [4:0]  RdE, 
input      [31:0] PCPlus4E,
input             ZeroE,
output reg [31:0] ALUResultM, WriteDataM,
output reg [4:0]  RdM, 
output reg [31:0] PCPlus4M,
output reg        ZeroM);

always @( posedge clk, posedge reset ) begin 
    if (reset) begin
        ALUResultM <= 0;
        WriteDataM <= 0;
        RdM <= 0; 
        PCPlus4M <= 0;
		  ZeroM <= 0;
    end

    else begin
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        RdM <= RdE; 
        PCPlus4M <= PCPlus4E;
        ZeroM <= ZeroE;     
    end
    
end

endmodule