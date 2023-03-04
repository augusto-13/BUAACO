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
    output [3:0] ALUControl,
    output [2:0] JumpOp,
    output [2:0] DMType,
    output [2:0] BType,
    output [1:0] EXTOp,
    output MemtoReg,
    output ALUSrc,
//  output RFWDSrc,
    output RegWrite,
    output MemWrite,
    output jal,
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
// j_Instr
wire is_jr    =   (is_R & `Funct == 6'b001000)?      1 : 0;
wire is_jalr  =   (is_R & `Funct == 6'b001001)?      1 : 0;
wire is_j     =   (`Op == 6'b000010)?                1 : 0;
wire is_jal   =   (`Op == 6'b000011)?                1 : 0;
// store
wire is_sw    =   (`Op == 6'b101011)?                1 : 0;
wire is_sb    =   (`Op == 6'b101000)?                1 : 0;
wire is_sh    =   (`Op == 6'b101001)?                1 : 0;
wire is_swr   =   (`Op == 6'b101110)?                1 : 0;
wire is_swl   =   (`Op == 6'b101010)?                1 : 0;
// load
// wire is_lw    =   (`Op == 6'b100011)?                1 : 0;
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
// b
wire is_bne   =   (`Op == 6'b000101)?                1 : 0;
wire is_beq   =   (`Op == 6'b000100)?                1 : 0;
wire is_bgtz  =   (`Op == 6'b000111 & `Op2 == 5'b00000)?                1 : 0;
wire is_bltz  =   (`Op == 6'b000001 & `Op2 == 5'b00000)?                1 : 0;
wire is_bgez  =   (`Op == 6'b000001 & `Op2 == 5'b00001)?                1 : 0;
wire is_blez  =   (`Op == 6'b000110 & `Op2 == 5'b00000)?                1 : 0;

// div / mult
wire is_div   =   (is_R & `Funct == 6'b011010)?      1 : 0;
wire is_divu  =   (is_R & `Funct == 6'b011011)?      1 : 0;
wire is_mult  =   (is_R & `Funct == 6'b011000)?      1 : 0;
wire is_multu =   (is_R & `Funct == 6'b011001)?      1 : 0;

// others
wire is_mfco  =   (`Op == 6'b010000 & `Op3 == 5'b00000)?                1 : 0;
wire is_mfhi  =   (is_R & `Funct == 6'b010000)?      1 : 0;
wire is_mflo  =   (is_R & `Funct == 6'b010010)?      1 : 0;
wire is_mtco  =   (`Op == 6'b010000 & `Op3 == 5'b00100)?                1 : 0; 
wire is_mthi  =   (is_R & `Funct == 6'b010001)?                         1 : 0;
wire is_mtlo  =   (is_R & `Funct == 6'b010011)?                         1 : 0;
wire is_nop   =   (Instr == 32'b0)?                  1 : 0;

// lwso
wire is_lwso  =   (`Op == 6'b100011)?                1 : 0;

//Operand
assign shamt = Instr[10:6];
assign rd = Instr[15:11];
assign rt = Instr[20:16];
assign rs = Instr[25:21];
assign Imm = Instr[15:0];
assign addr = Instr[25:0];

//ALUcontrol[3:0]
//E
assign ALUControl   =     (is_ori)?                                                                                                                       `ALU_or  :
                          (is_lw || is_sw || is_addu || is_lh || is_sh || is_lhu || is_lb || is_sb || is_lbu || is_swl || is_swr || is_lui || is_lwso)?   `ALU_add :
                          (is_subu)?                                                                                                                      `ALU_sub : `ALU_and;

//JumpOp[2:0]
//D
assign JumpOp       =     (is_j)?                 `JumpOp_j       :
                          (is_jal)?	              `JumpOp_jal     :
                          (is_jr)?	              `JumpOp_jr      :
                          (is_jalr)?              `JumpOp_jalr    :      `JumpOp_notj;

//DMType[2:0]
//M
assign DMType       =     (is_sw || is_lw || is_lwso)?       `DMType_word    :
                          (is_sh || is_lh)?                  `DMType_half    :
                          (is_sb || is_lb)?                  `DMType_byte    :
                          (is_lbu)?                          `DMType_byteu   :
                          (is_lhu)?                          `DMType_halfu   :
                          (is_swl)?                          `DMType_swl     :
                          (is_swr)?                          `DMType_swr     :     `DMType_word;

// BType[2:0]
//D
assign BType        =     (is_beq)?               `BType_beq      :
                          (is_bne)?               `BType_bne      :
                          (is_bgtz)?              `BType_bgtz     :
                          (is_bltz)?              `BType_bltz     :
                          (is_bgez)?              `BType_bgez     :
                          (is_blez)?              `BType_blez     :      `BType_notb;

//EXTOp[1:0]
//D
assign EXTOp        =     (is_sw || is_lw || is_beq || is_lh || is_sh || is_lhu || is_lb || is_sb || is_lbu || is_swl || is_swr || is_bgtz || is_bltz || is_bne || is_bgez || is_blez || is_lwso)?  `EXTOp_sign  :
                          (is_lui)?                                                                                                                                                                 `EXTOp_lui   :  `EXTOp_zero;

//1-bit signal
//W 
assign MemtoReg = is_lw   || is_lh   || is_lhu || is_lb  || is_lbu || is_lwso;
//E // Imm or rt
assign ALUSrc   = is_ori  || is_sw   || is_lw  || is_sh  || is_sb  || is_swl || is_swr || is_lui || is_lh || is_lb || is_lbu || is_lhu || is_lwso;
//W
assign RegWrite = is_addu || is_subu || is_ori || is_lw  || is_lui || is_jal || is_lh || is_lhu || is_lb  || is_lbu || is_jalr || is_add || is_sub || is_lwso;
//M
assign MemWrite = is_sw   || is_sh   || is_sb  || is_swr || is_swl;
//MW
assign jal      = is_jal  || is_jalr;
//
assign InstrType     =  (is_addu || is_subu || is_add || is_sub)?              `cal_R    :
                        (is_ori)?                                              `cal_Ist  :
                        (is_j)?                                                `j_addr   :
                        (is_jal)?                                              `j_l      :
                        (is_jr)?                                               `j_r      :
                        (is_jalr)?                                             `j_lr     :
                        (is_sw || is_sh || is_sb || is_swl || is_swr)?         `store    :
                        (is_lw || is_lhu || is_lh || is_lb || is_lbu)?         `load     :    
                        (is_beq || is_bne)?                                    `b_st     :
                        (is_blez || is_bgez || is_bltz || is_bgtz)?            `b_s      :
                        (is_nop)?                                              `nop      :
                        (is_lui)?                                              `cal_It   :
                        (is_lwso)?                                             `lwso     :    `InstrType_error;     
//W
assign RegDst = (InstrType == `cal_R)?                              rd :
                (InstrType == `cal_Ist)?                            rt :
                (InstrType == `cal_It)?                             rt : 
                (InstrType == `j_l)?                             5'd31 :
                (InstrType == `j_lr)?                               rd :
                (InstrType == `load)?                               rt :
                (InstrType == `lwso)?                               rt : 5'b0;
endmodule