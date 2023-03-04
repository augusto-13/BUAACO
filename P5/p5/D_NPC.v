`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:36:06 11/23/2021 
// Design Name: 
// Module Name:    NPC 
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

module D_NPC(
    input [31:0] PC,
    input [31:0] ExtendedImm,
    input [2:0] JumpOp,
    input BranchtoJump,
    input [25:0] addr,
    input [31:0] RD1,
    output [31:0] PC_
    );
wire [31:0] PC4 = PC + 32'd4;
assign  PC_ = (JumpOp == `JumpOp_jr)   ?  RD1 :
              (JumpOp == `JumpOp_j)    ? {{PC[31:28]}, {addr}, 2'b0} :
              (JumpOp == `JumpOp_jal)  ? {{PC[31:28]}, {addr}, 2'b0} :
              (JumpOp == `JumpOp_jalr) ?  RD1 :
              (BranchtoJump)           ? (PC + ( ExtendedImm << 2 )) : PC4;
//可以尝试一下直�(PC + 4)[31 : 28]是否可行
endmodule
