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
module CU(
    input [5:0] Op,
    input [5:0] Funct,
    output EXTOp,
    output [2:0] JumpOp,
    output MemtoReg,
    output ALUSrc,
    output RegDst,
    output RegWrite,
    output MemWrite,
    output [2:0] ALUControl,
    output beq,
    output [2:0] DMType,
    output lui,
    output jal,
    output bne,
    output bgtz,
    output bltz
    );

wire is_R     =   (Op == 6'b000000)?                1 : 0;
wire is_addu  =   (is_R & Funct == 6'b100001)?      1 : 0;
wire is_subu  =   (is_R & Funct == 6'b100011)?      1 : 0;
wire is_jr    =   (is_R & Funct == 6'b001000)?      1 : 0;
wire is_jalr  =   (is_R & Funct == 6'b001001)?      1 : 0;
wire is_ori   =   (Op == 6'b001101)?                1 : 0;
wire is_lw    =   (Op == 6'b100011)?                1 : 0;
wire is_sw    =   (Op == 6'b101011)?                1 : 0;
wire is_beq   =   (Op == 6'b000100)?                1 : 0;
wire is_lui   =   (Op == 6'b001111)?                1 : 0;
wire is_j     =   (Op == 6'b000010)?                1 : 0;
wire is_jal   =   (Op == 6'b000011)?                1 : 0;
wire is_lb    =   (Op == 6'b100000)?                1 : 0;
wire is_sb    =   (Op == 6'b101000)?                1 : 0;
wire is_lh    =   (Op == 6'b100001)?                1 : 0;
wire is_sh    =   (Op == 6'b101001)?                1 : 0;
wire is_lbu   =   (Op == 6'b100100)?                1 : 0;
wire is_lhu   =   (Op == 6'b100101)?                1 : 0;
wire is_swr   =   (Op == 6'b101110)?                1 : 0;
wire is_swl   =   (Op == 6'b101010)?                1 : 0;
wire is_bne   =   (Op == 6'b000101)?                1 : 0;
wire is_bgtz  =   (Op == 6'b000111)?                1 : 0;
wire is_bltz  =   (Op == 6'b000001)?                1 : 0;

//ALUcontrol[2:0]
assign ALUControl   =     (is_ori)?                                                                                                  `ALU_or  :
                          (is_lw || is_sw || is_addu || is_lh || is_sh || is_lhu || is_lb || is_sb || is_lbu || is_swl || is_swr)?   `ALU_add :
                          (is_subu)?                                                                                                 `ALU_sub : `ALU_and;

//JumpOp[2:0]
assign JumpOp       =     (is_j)?                 `JumpOp_j       :
                          (is_jal)?	              `JumpOp_jal     :
                          (is_jr)?	              `JumpOp_jr      :
                          (is_jalr)?              `JumpOp_jalr    :      3'b0;

//DMType[2:0]
assign DMType       =     (is_sw || is_lw)?       `DMType_word    :
                          (is_sh || is_lh)?       `DMType_half    :
                          (is_sb || is_lb)?       `DMType_byte    :
                          (is_lbu)?               `DMType_byteu   :
                          (is_lhu)?               `DMType_halfu   :
                          (is_swl)?               `DMType_swl     :
                          (is_swr)?               `DMType_swr     :     `DMType_word;


//1-bit signal
assign EXTOp    = is_sw   || is_lw   || is_beq || is_lh  || is_sh  || is_lhu || is_lb || is_sb  || is_lbu || is_swl || is_swr || is_bgtz || is_bltz || is_bne;
assign MemtoReg = is_lw   || is_lh   || is_lhu || is_lb  || is_lbu;
assign ALUSrc   = is_ori  || is_sw   || is_lw  || is_sh  || is_sb  || is_swl || is_swr;      // Imm or rt
assign RegDst   = is_addu || is_subu;                                                        // rd or rt
assign RegWrite = is_addu || is_subu || is_ori || is_lw  || is_lui || is_jal || is_lh || is_lhu || is_lb  || is_lbu || is_jalr;
assign MemWrite = is_sw   || is_sh   || is_sb  || is_swr || is_swl;
assign beq      = is_beq;
assign lui      = is_lui;
assign jal      = is_jal  || is_jalr;
assign bltz     = is_bltz;
assign bgtz     = is_bgtz;
assign bne      = is_bne;
endmodule