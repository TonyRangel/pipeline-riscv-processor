/*
	Name: Control Unit Pipeline Register between Instruction Execution and Memory Access Stage
*/


module c_IEx_IM (
input            clk, reset,
input            RegWriteE, MemWriteE,
input      [1:0] ResultSrcE,  
output reg       RegWriteM, MemWriteM,
output reg [1:0] ResultSrcM);

    always @( negedge clk, posedge reset ) begin
        if (reset) begin
            RegWriteM <= 0;
            MemWriteM <= 0;
            ResultSrcM <= 0;
        end
        else begin
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
            ResultSrcM <= ResultSrcE; 
        end
        
    end

endmodule