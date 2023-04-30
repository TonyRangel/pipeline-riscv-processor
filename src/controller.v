/*
	Name: Controller or Control Unit
	Description: 5 stage pipelined Control Unit
*/




module controller(
input         clk, reset,
input  [6:0]  op,
input  [2:0]  funct3,
input         funct7b5,
input         ZeroE,
input      	  SignE,
input  		  FlushE,

output  		  ResultSrcE0,
output  [1:0] ResultSrcW,
output  		  MemWriteM,
output  		  PCJalSrcE, PCSrcE, ALUSrcAE, 
output  [1:0] ALUSrcBE,
output  		  RegWriteM, RegWriteW,
output  [2:0] ImmSrcD,
output  [3:0] ALUControlE);

wire 	  [1:0] ALUOpD;
wire 	  [1:0] ResultSrcD, ResultSrcE, ResultSrcM;
wire    [3:0] ALUControlD;
wire          BranchD_q, BranchD_n, BranchE, MemWriteD, MemWriteE, JumpD, JumpE;
wire          ZeroOp, ALUSrcAD, RegWriteD, RegWriteE;
wire    [1:0] ALUSrcBD;
wire 			  SignOp;
wire 			  BranchOp;

// main decoder
//maindec md(op, ResultSrcD, MemWriteD, BranchD, ALUSrcAD, ALUSrcBD, RegWriteD, JumpD, ImmSrcD, ALUOpD);
control_signals ctl_sig(
												.op(op),
												.Funct3(funct3),
												.ResultSrc(ResultSrcD),
												.MemWrite(MemWriteD),
												.Branchq(BranchD_q), 
												.Branchn(BranchD_n), 
												.ALUSrcA(ALUSrcAD), 
												.ALUSrcB(ALUSrcBD),
												.RegWrite(), 
												.Jump(RegWriteD),
												.ImmSrc(ImmSrcD),
												.ALUOp(ALUOpD)

							   );

// alu decoder
//aludec ad(op[5], funct3, funct7b5, ALUOpD, ALUControlD);

aludec aludec				(
												.opb5(op[5]),
												.funct3(funct3),
												.funct7b5(funct7b5),
												.ALUOp(ALUOpD),
												.ALUControl(ALUControlD)
								 );


//c_ID_IEx c_pipreg0(clk, reset, FlushE, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcAD, ALUSrcBD, ResultSrcD, ALUControlD, 
//										RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcAE, ALUSrcBE, ResultSrcE, ALUControlE);
										
c_ID_IEx c_pipreg0      (
												.clk(), .reset(), .clear(),
												.RegWriteD(), .MemWriteD(), 
												.JumpD(), .BranchD(), .ALUSrcAD(),
												.ALUSrcBD(),
												.ResultSrcD(), 
												.ALUControlD(),
												  
												.RegWriteE(), 
												.MemWriteE(), 
												.JumpE(), 
												.BranchE(),  
												.ALUSrcAE(),
												.ALUSrcBE(),
												.ResultSrcE(),
												.ALUControlE()
                        );

assign ResultSrcE0 = ResultSrcE[0];

//c_IEx_IM c_pipreg1(clk, reset, RegWriteE, MemWriteE, ResultSrcE, RegWriteM,  MemWriteM, ResultSrcM);
c_IEx_IM c_pipreg1(
												.clk(), .reset(),
												.RegWriteE(), .MemWriteE(),
												.ResultSrcE(),  
												.RegWriteM(), .MemWriteM(),
												.ResultSrcM()
);

//c_IM_IW c_pipreg2 (clk, reset, RegWriteM, ResultSrcM, RegWriteW, ResultSrcW);
c_IM_IW c_pipreg2(
												.clk(), .reset(), 
												.RegWriteM(), 
												.ResultSrcM(), 
												.RegWriteW(), 
												.ResultSrcW()
);

assign ZeroOp = ZeroE ^ funct3[0]; // Complements Zero flag for BNE Instruction
assign SignOp = (SignE ^ funct3[0]) ; //Complements Sign for BGE

//mux2 BranchSrc (ZeroOp, SignOp, funct3[2], BranchOp); // fix this later
assign BranchOp = funct3[2] ? (SignOp) : (ZeroOp); 
assign PCSrcE = (BranchE & BranchOp) | JumpE;
assign PCJalSrcE = (op == 7'b1100111) ? 1 : 0; // jalr


endmodule