/*
	Name: Pipeline register between Datapath Fetch and Decode Stage
*/

module IF_ID (
  input  clk, reset, clear, enable,
  input      [31:0] InstrF, PCF, PCPlus4F,
  output reg [31:0] InstrD, PCD, PCPlus4D
);

  //always_ff @(posedge clk, posedge reset) begin
  always @( negedge clk, posedge reset) begin
    if (reset) begin // Asynchronous Clear
      InstrD <= 0;
      PCD <= 0;
      PCPlus4D <= 0;
    end
    else if (enable) begin
      if (clear) begin // Synchrnous Clear
        InstrD <= 0;
        PCD <= 0;
        PCPlus4D <= 0;
      end
      else begin
        InstrD <= InstrF;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
      end
    end
  end

endmodule