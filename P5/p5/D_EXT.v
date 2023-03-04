`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:00:59 11/23/2021 
// Design Name: 
// Module Name:    EXT 
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
module D_EXT(
    input [15:0] Imm,
    input [1:0]  EXTOp,
    output [31:0] ExtendedImm
    );

assign  ExtendedImm = (EXTOp == `EXTOp_sign)? {{16{Imm[15]}}, {Imm}} : 
                      (EXTOp == `EXTOp_zero)?         {16'b0, {Imm}} : {{Imm}, 16'b0} ;
endmodule
