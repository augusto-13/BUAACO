`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:11:27 11/23/2021 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "const.v"
module mips(
    input clk,
    input reset
    );
//wire//
//STAGE_F
wire [31:0] F_Instr, F_PC;
//STAGE_D
wire [31:0] D_Instr, D_PC, D_PC8, D_PC_, D_ExtendedImm, D_RD1rs, D_RD2rt, D_FWRD1rs, D_FWRD2rt;
wire [25:0] D_addr;
wire [15:0] D_Imm;
wire [4:0]  D_rt, D_rs;
wire [2:0]  D_JumpOp, D_BType;
wire [1:0]  D_EXTOp;
wire D_Branchtojump;
//STAGE E
wire [31:0] E_Instr, E_ExtendedImm, E_PC8, E_ALUResult, E_RD2rt, E_FWRD2rt, E_RD1rs, E_FWRD1rs, E_ALUSrcB;
wire [3:0]  E_ALUControl; 
wire E_ALUSrc;// ***** MUX (rt or Imm)
// STAGE M	
wire [31:0] M_Instr, M_PC8, M_ALUResult, M_RD2rt, M_FWRD2rt, M_PC, M_RD;
wire [2:0]  M_DMType;
wire M_MemWrite, M_jal/*PC8_mux*/;
//STAGE W
wire [31:0] W_Instr, W_PC8, W_RD, W_ALUResult, W_WD3, W_PC;
wire [5:0]  W_InstrType;
wire [4:0]  W_RegDst;
wire W_MemtoReg, W_RegWrite, W_jal, W_lwso_yes;
//FSU
wire [1:0] FWMux_Ers_Sel;
wire [1:0] FWMux_Ert_Sel;
wire [1:0] FWMux_Drs_Sel;
wire [1:0] FWMux_Drt_Sel;
wire FWMux_Mrt_Sel;
wire stall;

// MUX 1 : DataPath
assign E_ALUSrcB = (E_ALUSrc)? E_ExtendedImm : E_FWRD2rt;
assign W_WD3     = (W_jal)?	           W_PC8 :/*因为有延迟槽，应回写PC+8*/   
				   (W_MemtoReg)?        W_RD : W_ALUResult;

// MUX 2 : jal
wire [31:0] E_FWSrc = E_PC8;
wire [31:0] M_FWSrc = (M_jal)?	 M_PC8 : M_ALUResult;
wire [31:0] W_FWSrc = (W_jal)?   W_PC8 : W_WD3;

// MUX 3 : FW
assign D_FWRD1rs = (FWMux_Drs_Sel == 2'b11)? E_FWSrc :
				   (FWMux_Drs_Sel == 2'b10)? M_FWSrc :
				   (FWMux_Drs_Sel == 2'b01)? W_FWSrc : D_RD1rs;
assign D_FWRD2rt = (FWMux_Drt_Sel == 2'b11)? E_FWSrc :
				   (FWMux_Drt_Sel == 2'b10)? M_FWSrc :
				   (FWMux_Drt_Sel == 2'b01)? W_FWSrc : D_RD2rt;
assign E_FWRD1rs = (FWMux_Ers_Sel == 2'b10)? M_FWSrc :
				   (FWMux_Ers_Sel == 2'b01)? W_FWSrc : E_RD1rs;
assign E_FWRD2rt = (FWMux_Ert_Sel == 2'b10)? M_FWSrc :
				   (FWMux_Ert_Sel == 2'b01)? W_FWSrc : E_RD2rt;
assign M_FWRD2rt = (FWMux_Mrt_Sel)? W_FWSrc : M_RD2rt; 


//STAGE_F
F_IFU F_Ifu (
		.PC_(D_PC_), 
		.clk(clk), 
		.EN(~stall),
		.reset(reset), 
		.Instr(F_Instr), 
		.PC(F_PC)
	);

//STAGE_D
D_REG D_reg (
		.clk(clk), 
		.reset(reset), 
		.WE(~stall), 
		.Instr_in(F_Instr), 
		.PC_in(F_PC), 
		.Instr_out(D_Instr), 
		.PC_out(D_PC)
	);


D_GRF D_Grf (
		.PC(W_PC), 
		.reset(reset), 
		.clk(clk), 
		.A1(D_rs), 
		.A2(D_rt),
		.RD1(D_RD1rs), 
		.RD2(D_RD2rt),
		.we((W_InstrType == `lwso)? W_lwso_yes : W_RegWrite),
		.A3(W_RegDst), 
		.WD3(W_WD3)
	);

D_EXT D_Ext (
		.Imm(D_Imm), 
		.EXTOp(D_EXTOp), 
		.ExtendedImm(D_ExtendedImm)
	);

D_BranchIf D_Branchif (
		.BType(D_BType),
		.RD1rs(D_FWRD1rs),//FW
		.RD2rt(D_FWRD2rt),//FW
		.BranchtoJump(D_BranchtoJump)
	);

D_NPC D_Npc (
		.PC(F_PC), 
		.ExtendedImm(D_ExtendedImm), 
		.JumpOp(D_JumpOp), 
		.BranchtoJump(D_BranchtoJump), 
		.addr(D_addr), 
		.RD1(D_FWRD1rs), 
		.PC_(D_PC_)
	);

assign D_PC8 = D_PC + 32'd8;

//STAGE E
E_REG E_Reg (
		.clk(clk), 
		.reset((reset)? reset : stall), 
		.WE(1'b1), 
		.Instr_in(D_Instr), 
		.PC8_in(D_PC8), 
		.FWRD1_in(D_FWRD1rs), 
		.FWRD2_in(D_FWRD2rt), 
		.ExtendedImm_in(D_ExtendedImm), 
		.Instr_out(E_Instr), 
		.PC8_out(E_PC8), 
		.FWRD1_out(E_RD1rs), 
		.FWRD2_out(E_RD2rt), 
		.ExtendedImm_out(E_ExtendedImm)
	);

E_ALU E_Alu (
		.SrcA(E_FWRD1rs), 
		.SrcB(E_ALUSrcB), 
		.ALUControl(E_ALUControl), 
		.ALUResult(E_ALUResult)
	);

// STAGE M	
M_REG M_Reg (
		.clk(clk), 
		.reset(reset), 
		.WE(1'b1), 
		.Instr_in(E_Instr), 
		.PC8_in(E_PC8), 
		.ALUResult_in(E_ALUResult), 
		.FWRD2rt_in(E_FWRD2rt), 
		.Instr_out(M_Instr), 
		.PC8_out(M_PC8), 
		.ALUResult_out(M_ALUResult), 
		.FWRD2rt_out(M_RD2rt)
	);

assign M_PC = M_PC8 - 8;
M_DM M_Dm (
		.PC(M_PC), 
		.clk(clk), 
		.reset(reset), 
		.A(M_ALUResult), 
		.WD(M_FWRD2rt), 
		.we(M_MemWrite), 
		.DMType(M_DMType), 
		.RD(M_RD)
	);

//STAGE W
W_REG W_Reg (
		.clk(clk), 
		.reset(reset), 
		.WE(1'b1), 
		.Instr_in(M_Instr), 
		.PC8_in(M_PC8), 
		.RD_in(M_RD), 
		.ALUResult_in(M_ALUResult), 
		.Instr_out(W_Instr), 
		.PC8_out(W_PC8), 
		.RD_out(W_RD), 
		.ALUResult_out(W_ALUResult)
	);

assign W_PC = W_PC8 - 8;
assign W_lwso_yes = (W_InstrType == `lwso) & (W_RD[31] == 0);
/*
D_GRF D_Grf (
		.we(W_RegWrite),
		.A3(W_RegDst), 
		.WD3(W_WD3)
	);
*/
//Decoder
Decoder D_Decoder (
	.Instr(D_Instr), 
	.rs(D_rs), 
	.rt(D_rt),   
	.Imm(D_Imm), 
	.addr(D_addr), 
	.JumpOp(D_JumpOp), 
	.BType(D_BType), 
	.EXTOp(D_EXTOp)
);
Decoder E_Decoder (
	.Instr(E_Instr), 
	.ALUControl(E_ALUControl), 
	.ALUSrc(E_ALUSrc)
);
Decoder M_Decoder (
	.Instr(M_Instr), 
	.DMType(M_DMType),
	.MemWrite(M_MemWrite), 
	.jal(M_jal)
);
Decoder W_Decoder (
	.Instr(W_Instr), 
	.MemtoReg(W_MemtoReg),
	.RegWrite(W_RegWrite), 
	.jal(W_jal),
	.RegDst(W_RegDst),
	.InstrType(W_InstrType)
);

// FSU
	FSU fsu (
		.W_lwso_yes(W_lwso_yes),
		.FSU_DInstr(D_Instr), 
		.FSU_EInstr(E_Instr), 
		.FSU_MInstr(M_Instr), 
		.FSU_WInstr(W_Instr), 
		.stall(stall), 
		.FWMux_Ers_Sel(FWMux_Ers_Sel), 
		.FWMux_Ert_Sel(FWMux_Ert_Sel), 
		.FWMux_Drs_Sel(FWMux_Drs_Sel), 
		.FWMux_Drt_Sel(FWMux_Drt_Sel), 
		.FWMux_Mrt_Sel(FWMux_Mrt_Sel)
	); 
endmodule