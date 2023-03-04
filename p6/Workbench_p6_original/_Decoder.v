`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:06:17 11/23/2021 
// Design Name: 
// Module Name:    CU 
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
`define Op  Instr[31:26]
`define Op2 Instr[20:16]
`define Op3 Instr[25:21]
`define Funct Instr [5:0]
module Decoder(
    input [31:0] Instr,
    // `Operand
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [15:0] Imm,
    output [25:0] addr,
    // Control_Unit
    output [4:0] HILOType,
    output [3:0] ALUControl,
    output [2:0] JumpOp,
    output [2:0] DMType,
    output [2:0] BType,
    output [2:0] EXTOp,
    output [1:0] ALUSrcA_Sel,
    output [1:0] ALUSrcB_Sel,
    output MemtoReg,
    output RegWrite,
    output MemWrite,
    output jal,
    output MUX_ALUorHILO,
    // Instr_Type
    output [5:0] InstrType,
    output [4:0] RegDst
    );

// Instr 1 ~ 39
wire is_R     =   (`Op == 6'b000000)?                1 : 0;
// cal_R
wire is_addu  =   (is_R & `Funct == 6'b100001)?      1 : 0;
wire is_subu  =   (is_R & `Funct == 6'b100011)?      1 : 0;
wire is_add   =   (is_R & `Funct == 6'b100000)?      1 : 0;
wire is_sub   =   (is_R & `Funct == 6'b100010)?      1 : 0;
wire is_and   =   (is_R & `Funct == 6'b100100)?      1 : 0;
wire is_nor   =   (is_R & `Funct == 6'b100111)?      1 : 0;
wire is_or    =   (is_R & `Funct == 6'b100101)?      1 : 0;
wire is_xor   =   (is_R & `Funct == 6'b100110)?      1 : 0;
wire is_slt   =   (is_R & `Funct == 6'b101010)?      1 : 0;
wire is_sltu  =   (is_R & `Funct == 6'b101011)?      1 : 0;
wire is_sllv  =   (is_R & `Funct == 6'b000100)?      1 : 0;
wire is_srav  =   (is_R & `Funct == 6'b000111)?      1 : 0;
wire is_srlv  =   (is_R & `Funct == 6'b000110)?      1 : 0;
// j_Instr
wire is_jr    =   (is_R & `Funct == 6'b001000)?      1 : 0;
wire is_jalr  =   (is_R & `Funct == 6'b001001)?      1 : 0;
wire is_j     =   (`Op == 6'b000010)?                1 : 0;
wire is_jal   =   (`Op == 6'b000011)?                1 : 0;
// store
wire is_sw    =   (`Op == 6'b101011)?                1 : 0;
wire is_sb    =   (`Op == 6'b101000)?                1 : 0;
wire is_sh    =   (`Op == 6'b101001)?                1 : 0;
// load
wire is_lw    =   (`Op == 6'b100011)?                1 : 0;
wire is_lb    =   (`Op == 6'b100000)?                1 : 0;
wire is_lh    =   (`Op == 6'b100001)?                1 : 0;
wire is_lbu   =   (`Op == 6'b100100)?                1 : 0;
wire is_lhu   =   (`Op == 6'b100101)?                1 : 0;
// cal_I
wire is_ori   =   (`Op == 6'b001101)?                1 : 0;
wire is_lui   =   (`Op == 6'b001111)?                1 : 0;
wire is_addiu =   (`Op == 6'b001001)?                1 : 0;
wire is_addi  =   (`Op == 6'b001000)?                1 : 0;
wire is_andi  =   (`Op == 6'b001100)?                1 : 0;
wire is_slti  =   (`Op == 6'b001010)?                1 : 0;
wire is_sltiu =   (`Op == 6'b001011)?                1 : 0;
wire is_xori  =   (`Op == 6'b001110)?                1 : 0;
// b
wire is_bne   =   (`Op == 6'b000101)?                1 : 0;
wire is_beq   =   (`Op == 6'b000100)?                1 : 0;
wire is_bgtz  =   (`Op == 6'b000111 & `Op2 == 5'b00000)?                1 : 0;
wire is_bltz  =   (`Op == 6'b000001 & `Op2 == 5'b00000)?                1 : 0;
wire is_bgez  =   (`Op == 6'b000001 & `Op2 == 5'b00001)?                1 : 0;
wire is_blez  =   (`Op == 6'b000110 & `Op2 == 5'b00000)?                1 : 0;

// hilo
wire is_div   =   (is_R & `Funct == 6'b011010)?      1 : 0;
wire is_divu  =   (is_R & `Funct == 6'b011011)?      1 : 0;
wire is_mult  =   (is_R & `Funct == 6'b011000)?      1 : 0;
wire is_multu =   (is_R & `Funct == 6'b011001)?      1 : 0;
wire is_mfhi  =   (is_R & `Funct == 6'b010000)?      1 : 0;
wire is_mflo  =   (is_R & `Funct == 6'b010010)?      1 : 0;
wire is_mthi  =   (is_R & `Funct == 6'b010001)?      1 : 0;
wire is_mtlo  =   (is_R & `Funct == 6'b010011)?      1 : 0;

//shamt
wire is_sll   = (is_R & `Funct == 6'b000000)?        1 : 0;
wire is_sra   = (is_R & `Funct == 6'b000011)?        1 : 0;
wire is_srl   = (is_R & `Funct == 6'b000010)?        1 : 0;

//syscall
wire is_syscall = (is_R & `Funct == 6'b001100)?      1 : 0;
wire is_break   = (is_R & `Funct == 6'b001101)?      1 : 0;
wire is_eret    = (Instr == 32'b010000_1000_0000_0000_0000_0000_011000)?    1 : 0; 
wire is_mtc0  =   (`Op == 6'b010000 & `Op3 == 5'b00100)?                1 : 0; 
wire is_mfc0  =   (`Op == 6'b010000 & `Op3 == 5'b00000)?                1 : 0;

//Operand
assign shamt = Instr[10:6];
assign rd = Instr[15:11];
assign rt = Instr[20:16];
assign rs = Instr[25:21];
assign Imm = Instr[15:0];
assign addr = Instr[25:0];

// ALUcontrol[3:0] (32_Instrs)
//E
assign ALUControl   =     (is_ori || is_or)?                              `ALU_or  :
                          (is_and || is_andi)?                            `ALU_and :
                          (is_xor || is_xori)?                            `ALU_xor :
                          (is_nor)?                                       `ALU_nor :
                          (is_lw || is_lh || is_lhu || is_lb || is_lbu)?  `ALU_add :
                          (is_sh || is_sw || is_sb)?                      `ALU_add :
                          (is_addu || is_add || is_addi || is_addiu)?     `ALU_add :
                          (is_lui)?                                       `ALU_add :
                          (is_subu || is_sub)?                            `ALU_sub :
                          (is_sll || is_sllv)?                            `ALU_sll :
                          (is_srl || is_srlv)?                            `ALU_srl :
                          (is_sra || is_srav)?                            `ALU_sra :
                          (is_slt || is_slti)?                            `ALU_slt :
                          (is_sltu || is_sltiu)?                         `ALU_sltu : `ALU_and;

// JumpOp[2:0] (4_Instrs)
//D
assign JumpOp = (is_j)?     `JumpOp_j    :
                (is_jal)?	`JumpOp_jal  :
                (is_jr)?	`JumpOp_jr   :
                (is_jalr)?  `JumpOp_jalr : `JumpOp_notj;

// DMType[2:0] (8_Instrs)
//M
assign DMType = (is_sw || is_lw)?   `DMType_word  :
                (is_sh || is_lh)?   `DMType_half  :
                (is_sb || is_lb)?   `DMType_byte  :
                (is_lbu)?           `DMType_byteu :
                (is_lhu)?           `DMType_halfu : `DMType_null;

// BType[2:0] (6_Instrs)
//D
assign BType  = (is_beq)?   `BType_beq  :
                (is_bne)?   `BType_bne  :
                (is_bgtz)?  `BType_bgtz :
                (is_bltz)?  `BType_bltz :
                (is_bgez)?  `BType_bgez :
                (is_blez)?  `BType_blez : `BType_notb;

// EXTOp[2:0] (25_Instrs)
//D
assign EXTOp  = (is_lw || is_lh || is_lhu || is_lb || is_lbu)?  `EXTOp_sign  :
                (is_sw || is_sb || is_sh)?                      `EXTOp_sign  :
                (is_bgtz || is_bltz || is_bgez || is_blez)?     `EXTOp_sign  :
                (is_beq || is_bne)?                             `EXTOp_sign  :
                (is_andi || is_ori || is_xori)?                 `EXTOp_zero  :
                (is_slti || is_sltiu || is_addi || is_addiu)?   `EXTOp_sign  :
                (is_lui)?                                       `EXTOp_lui   :
                (is_sll || is_srl || is_sra)?                   `EXTOp_shamt : `EXTOp_null;
// ALUSrcA\B[1:0]
//E // Imm or rt or rs
assign ALUSrcA_Sel = (is_sll || is_srl || is_sra || is_sllv || is_srlv || is_srav)?             `ALUSrc_rt   : `ALUSrc_rs;
assign ALUSrcB_Sel = (is_lw || is_lh || is_lhu || is_lb || is_lbu)?  `ALUSrc_Imm  :
                     (is_sw || is_sb || is_sh)?                      `ALUSrc_Imm  :
                     (is_bgtz || is_bltz || is_bgez || is_blez)?     `ALUSrc_Imm  :
                     (is_beq || is_bne)?                             `ALUSrc_Imm  :
                     (is_andi || is_ori || is_xori)?                 `ALUSrc_Imm  :
                     (is_slti || is_sltiu || is_addi || is_addiu)?   `ALUSrc_Imm  :
                     (is_lui)?                                       `ALUSrc_Imm  :
                     (is_sll || is_srl || is_sra)?                   `ALUSrc_Imm  :
                     (is_sllv || is_srlv || is_srav)?                `ALUSrc_rs   :   `ALUSrc_rt;
//1-bit signal
//W 
assign MemtoReg = (InstrType == `load);
//W
assign RegWrite = (InstrType == `cal_R) || (InstrType == `shift_R) || (InstrType == `cal_Ist) || (InstrType == `cal_It) || (InstrType == `load) || (InstrType == `j_l) || (InstrType == `j_lr) || (InstrType == `hilo_mf);
//M
assign MemWrite = (InstrType == `store);
//MW
assign jal      = (InstrType == `j_l) || (InstrType == `j_lr);
//E
assign MUX_ALUorHILO = (InstrType == `hilo_mf)? `MUX_HILO : `MUX_ALU;
//
assign InstrType     =  (is_addu || is_subu || is_add || is_sub)?                    `cal_R    :
                        (is_and || is_or || is_nor || is_xor)?                       `cal_R    :
                        (is_slt || is_sltu)?                                         `cal_R    :
                        (is_sllv || is_srlv || is_srav)?                             `cal_R    :
                        (is_ori || is_xori || is_andi)?                              `cal_Ist  :
                        (is_addi || is_addiu)?                                       `cal_Ist  :
                        (is_slti || is_sltiu)?                                       `cal_Ist  :
                        (is_lui)?                                                    `cal_It   : 
                        (is_j)?                                                      `j_addr   :
                        (is_jal)?                                                    `j_l      :
                        (is_jr)?                                                     `j_r      :
                        (is_jalr)?                                                   `j_lr     :
                        (is_sw || is_sh || is_sb)?                                   `store    :
                        (is_lw || is_lhu || is_lh || is_lb || is_lbu)?               `load     :    
                        (is_beq || is_bne)?                                          `b_st     :
                        (is_blez || is_bgez || is_bltz || is_bgtz)?                  `b_s      :
                        (is_syscall || is_break || is_eret || is_mtc0 || is_mfc0)?   `syscall  :
                        (is_div || is_divu || is_mult || is_multu)?                  `hilo_cal :
                        (is_mfhi || is_mflo)?                                        `hilo_mf  :
                        (is_mthi || is_mtlo)?                                        `hilo_mt  :
                        (is_sll || is_srl || is_sra)?                                `shift_R  :  `InstrType_error;     
  
//W
assign RegDst = (InstrType == `cal_R)?                              rd :
                (InstrType == `shift_R)?                            rd :
                (InstrType == `cal_Ist)?                            rt :
                (InstrType == `cal_It)?                             rt :
                (InstrType == `load)?                               rt :  
                (InstrType == `j_l)?                             5'd31 :
                (InstrType == `j_lr)?                               rd :
                (InstrType == `hilo_mf)?                            rd : 5'd0;

assign HILOType = (is_div)?         `HILOType_div   :
                  (is_divu)?        `HILOType_divu  : 
                  (is_mult)?        `HILOType_mult  : 
                  (is_multu)?       `HILOType_multu : 
                  (is_mfhi)?        `HILOType_mfhi  : 
                  (is_mflo)?        `HILOType_mflo  : 
                  (is_mthi)?        `HILOType_mthi  : 
                  (is_mtlo)?        `HILOType_mtlo  :  `HILOType_error;
endmodule