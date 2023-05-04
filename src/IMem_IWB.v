/*
	Name: Pipeline register between Memory Access and WriteBack Stage
*/




module IMem_IWB(input             clk, reset,
                input      [31:0] ALUResultM, ReadDataM,  
                input      [4:0]  RdM, 
                input      [31:0] PCPlus4M,
                output reg [31:0] ALUResultW, ReadDataW,
                output reg [4:0]  RdW, 
                output reg [31:0] PCPlus4W);

always @( negedge clk, posedge reset ) begin 
    if (reset) begin
        ALUResultW <= 0;
        ReadDataW <= 0;
        
        RdW <= 0; 
        PCPlus4W <= 0;
    end

    else begin
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        
        RdW <= RdM; 
        PCPlus4W <= PCPlus4M;        
    end
    
end

endmodule