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
module mips(
    input clk,
    input reset
    );

// WriteData -> RD2/ ReadData -> RD 直接删去，使模块简洁化（DM, Prereading, Prewriting已合体）
wire [31:0] PC_, PC, Instr, RD1, RD2, WD3, ExtendedImm, ALUResult, RD;
wire [25:0] addr;
wire [15:0] Imm; 
wire [5:0]  Op, Funct;
wire [4:0]  shamt, rd, rt, rs;
wire [2:0]  ALUControl, DMType, JumpOp;
wire  RegWrite, RegDst, BranchtoJump, EXTOp, lui, MemtoReg, beq, jal, MemWrite, bne, bltz, bgtz;
ALU Alu (
		.SrcA(RD1), 
		.SrcB((ALUSrc == 1)? ExtendedImm : RD2), 
		.ALUControl(ALUControl), 
		.ALUResult(ALUResult)
	);
CU Cu (
		.Op(Op), 
		.Funct(Funct), 
		.EXTOp(EXTOp), 
		.JumpOp(JumpOp), 
		.MemtoReg(MemtoReg), 
		.ALUSrc(ALUSrc), 
		.RegDst(RegDst), 
		.RegWrite(RegWrite), 
		.MemWrite(MemWrite), 
		.ALUControl(ALUControl), 
		.beq(beq), 
		.DMType(DMType), 
		.lui(lui),
        .jal(jal),
		.bne(bne),
		.bgtz(bgtz),
		.bltz(bltz)
	);

BranchIf Branchif (
		.beq(beq),
		.bne(bne),
		.bgtz(bgtz),
		.bltz(bltz), 
		.RD1_rs(RD1), 
		.RD2_rt(RD2),
		.BranchtoJump(BranchtoJump)
	);

DM Dm (
		.PC(PC), 
		.clk(clk), 
		.reset(reset), 
		.A(ALUResult), 
		.WD(RD2), 
		.we(MemWrite), 
		.DMType(DMType), 
		.RD(RD)
	);

EXT Ext (
		.Imm(Imm), 
		.EXTOp(EXTOp), 
		.ExtendedImm(ExtendedImm)
	);

GRF Grf (
		.PC(PC), 
		.reset(reset), 
		.clk(clk), 
		.we(RegWrite), 
		.A1(rs), 
		.A2(rt), 
		.A3(  (jal == 1)?                5'd31 :
              (RegDst == 1)?               rd  :  rt), 
		.WD3( (jal == 1)?               PC + 4 :
              (lui == 1)?         {Imm, 16'b0} :
              (MemtoReg == 1)?              RD :  ALUResult), 
		.RD1(RD1), 
		.RD2(RD2)
	);

IFU Ifu (
		.PC_(PC_), 
		.clk(clk), 
		.reset(reset), 
		.Instr(Instr), 
		.Op(Op), 
		.Funct(Funct), 
		.shamt(shamt), 
		.rd(rd), 
		.rs(rs), 
		.rt(rt), 
		.Imm(Imm), 
		.addr(addr), 
		.PC(PC)
	);

NPC Npc (
		.PC(PC), 
		.ExtendedImm(ExtendedImm), 
		.JumpOp(JumpOp), 
		.BranchtoJump(BranchtoJump), 
		.addr(addr), 
		.RD1(RD1), 
		.PC_(PC_)
	);
endmodule


