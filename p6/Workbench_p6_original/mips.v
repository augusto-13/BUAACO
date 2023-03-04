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
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
//wire//
//STAGE_F
wire [31:0] F_Instr, F_PC;
//STAGE_D
wire [31:0] D_Instr, D_PC, D_PC8, D_PC_, D_ExtendedImm, D_RD1rs, D_RD2rt, D_FWRD1rs, D_FWRD2rt;
wire [25:0] D_addr;
wire [15:0] D_Imm;
wire [4:0]  D_rt, D_rs, D_shamt;
wire [2:0]  D_JumpOp, D_BType, D_EXTOp;
wire D_Branchtojump;
//STAGE E
wire [31:0] E_Instr, E_ExtendedImm, E_PC8, E_ALUResult, E_HILOResult, E_Result, E_RD2rt, E_FWRD2rt, E_RD1rs, E_FWRD1rs, E_ALUSrcB, E_ALUSrcA;
wire [4:0]  E_HILOType;
wire [3:0]  E_ALUControl;
wire [1:0]  E_ALUSrcA_Sel, E_ALUSrcB_Sel;
wire E_MUX_ALUorHILO, E_HILObusy;
// STAGE M	
wire [31:0] M_Instr, M_PC8, M_Result, M_RD2rt, M_FWRD2rt, M_PC, M_RD;
wire [5:0]  M_InstrType;
wire [2:0]  M_DMType;
wire M_MemWrite, M_jal /*PC8_mux*/;
//STAGE W
wire [31:0] W_Instr, W_PC8, W_RD, W_Result, W_WD3, W_PC;
wire [4:0]  W_RegDst;
wire W_MemtoReg, W_RegWrite, W_jal;
//FSU
wire [1:0] FWMux_Ers_Sel;
wire [1:0] FWMux_Ert_Sel;
wire [1:0] FWMux_Drs_Sel;
wire [1:0] FWMux_Drt_Sel;
wire FWMux_Mrt_Sel;
wire stall;

// MUX 1 : DataPath
assign E_ALUSrcA = (E_ALUSrcA_Sel == `ALUSrc_rs)?       E_FWRD1rs :
				   (E_ALUSrcA_Sel == `ALUSrc_rt)?       E_FWRD2rt :
				   (E_ALUSrcA_Sel == `ALUSrc_Imm)?  E_ExtendedImm : 32'b0;
assign E_ALUSrcB = (E_ALUSrcB_Sel == `ALUSrc_Imm)?  E_ExtendedImm :
				   (E_ALUSrcB_Sel == `ALUSrc_rt)?       E_FWRD2rt :
				   (E_ALUSrcB_Sel == `ALUSrc_rs)?       E_FWRD1rs : 32'b0;
assign W_WD3     = (W_jal)?	           W_PC8 : 
				   (W_MemtoReg)?        W_RD : W_Result;
assign E_Result  = (E_MUX_ALUorHILO == `MUX_ALU)?   E_ALUResult : E_HILOResult;

// MUX 2 : jal
wire [31:0] E_FWSrc = E_PC8;
wire [31:0] M_FWSrc = (M_jal)?	 M_PC8 : M_Result;
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
assign M_FWRD2rt = (FWMux_Mrt_Sel)?          W_FWSrc : M_RD2rt; 

// mips_input_adjustment
assign F_Instr = i_inst_rdata;
assign M_RD   = (M_DMType == `DMType_word)?  																				   m_data_rdata :
				(M_DMType == `DMType_half)? 	  {{16{m_data_rdata[16 * M_Result[1] + 15]}},{m_data_rdata[16 * M_Result[1]  +: 16]}} :
				(M_DMType == `DMType_byte)? 	{{24{m_data_rdata[8 *  M_Result[1:0] + 7 ]}},{m_data_rdata[8 * M_Result[1:0] +:  8]}} :
				(M_DMType == `DMType_halfu)? 	                                      {16'b0,{m_data_rdata[16 * M_Result[1]  +: 16]}} :
				(M_DMType == `DMType_byteu)? 	                                      {24'b0,{m_data_rdata[8 * M_Result[1:0] +:  8]}} : 32'b0;


// mips_output_adjustment
assign i_inst_addr   = F_PC;
assign m_data_addr   = M_Result;
assign m_data_wdata  = (M_DMType == `DMType_word & M_InstrType == `store)?							 						M_FWRD2rt : 
					   (M_DMType == `DMType_half & M_InstrType == `store & M_Result[1] == 1'b0)?  						M_FWRD2rt :
					   (M_DMType == `DMType_half & M_InstrType == `store & M_Result[1] == 1'b1)?  	     {M_FWRD2rt[15:0], 16'b0} :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b00)?   	  				M_FWRD2rt :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b01)?  {16'b0, M_FWRD2rt[7:0], 8'b0} :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b10)?  {8'b0, M_FWRD2rt[7:0], 16'b0} :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b11)?        {M_FWRD2rt[7:0], 24'b0} : 4'b0000;
assign m_data_byteen = (M_DMType == `DMType_word & M_InstrType == `store)?						 	4'b1111 : 
					   (M_DMType == `DMType_half & M_InstrType == `store & M_Result[1] == 1'b0)?  	4'b0011 :
					   (M_DMType == `DMType_half & M_InstrType == `store & M_Result[1] == 1'b1)?  	4'b1100 :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b00)?  4'b0001 :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b01)?  4'b0010 :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b10)?  4'b0100 :
					   (M_DMType == `DMType_byte & M_InstrType == `store & M_Result[1:0] == 2'b11)?  4'b1000 : 4'b0000;
assign m_inst_addr = M_PC;
assign w_grf_we = W_RegWrite;
assign w_grf_addr = W_RegDst;
assign w_grf_wdata = W_WD3;
assign w_inst_addr = W_PC;
//STAGE_F
F_IFU F_Ifu (
		.PC_(D_PC_), 
		.clk(clk), 
		.EN(~stall),
		.reset(reset),
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
		.we(W_RegWrite),
		.A3(W_RegDst), 
		.WD3(W_WD3)
	);

D_EXT D_Ext (
		.Imm(D_Imm),
		.shamt(D_shamt),
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
		.SrcA(E_ALUSrcA), 
		.SrcB(E_ALUSrcB), 
		.ALUControl(E_ALUControl), 
		.ALUResult(E_ALUResult)
	);

E_HILO E_Hilo (
		.clk(clk), 
		.reset(reset), 
		.A_rs(E_FWRD1rs), 
		.B_rt(E_FWRD2rt), 
		.HILOType(E_HILOType),
		.HILObusy(E_HILObusy),
		.HILOResult(E_HILOResult)
	);
// STAGE M	
M_REG M_Reg (
		.clk(clk), 
		.reset(reset), 
		.WE(1'b1), 
		.Instr_in(E_Instr), 
		.PC8_in(E_PC8), 
		.Result_in(E_Result), 
		.FWRD2rt_in(E_FWRD2rt), 
		.Instr_out(M_Instr), 
		.PC8_out(M_PC8), 
		.Result_out(M_Result), 
		.FWRD2rt_out(M_RD2rt)
	);

assign M_PC = M_PC8 - 8;

//STAGE W
W_REG W_Reg (
		.clk(clk), 
		.reset(reset), 
		.WE(1'b1), 
		.Instr_in(M_Instr), 
		.PC8_in(M_PC8), 
		.RD_in(M_RD), 
		.Result_in(M_Result), 
		.Instr_out(W_Instr), 
		.PC8_out(W_PC8), 
		.RD_out(W_RD), 
		.Result_out(W_Result)
	);

assign W_PC = W_PC8 - 8;

//Decoder
Decoder D_Decoder (
	.Instr(D_Instr), 
	.rs(D_rs), 
	.rt(D_rt),   
	.Imm(D_Imm), 
	.addr(D_addr), 
	.shamt(D_shamt),
	.JumpOp(D_JumpOp), 
	.BType(D_BType), 
	.EXTOp(D_EXTOp)
);
Decoder E_Decoder (
	.Instr(E_Instr), 
	.ALUControl(E_ALUControl), 
	.ALUSrcA_Sel(E_ALUSrcA_Sel),
	.ALUSrcB_Sel(E_ALUSrcB_Sel),
	.MUX_ALUorHILO(E_MUX_ALUorHILO),
	.HILOType(E_HILOType)
);
Decoder M_Decoder (
	.Instr(M_Instr), 
	.DMType(M_DMType),
	.MemWrite(M_MemWrite), 
	.jal(M_jal),
	.InstrType(M_InstrType)
);
Decoder W_Decoder (
	.Instr(W_Instr), 
	.MemtoReg(W_MemtoReg),
	.RegWrite(W_RegWrite), 
	.jal(W_jal),
	.RegDst(W_RegDst)
);

// FSU
	FSU fsu (
		.FSU_DInstr(D_Instr), 
		.FSU_EInstr(E_Instr), 
		.FSU_MInstr(M_Instr), 
		.FSU_WInstr(W_Instr), 
		.E_HILObusy(E_HILObusy),
		.stall(stall), 
		.FWMux_Ers_Sel(FWMux_Ers_Sel), 
		.FWMux_Ert_Sel(FWMux_Ert_Sel), 
		.FWMux_Drs_Sel(FWMux_Drs_Sel), 
		.FWMux_Drt_Sel(FWMux_Drt_Sel), 
		.FWMux_Mrt_Sel(FWMux_Mrt_Sel)
	); 

endmodule