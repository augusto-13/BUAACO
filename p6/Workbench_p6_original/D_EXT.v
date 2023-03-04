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
    input [15:0]  Imm,
    input [4:0]   shamt,
    input [2:0]   EXTOp,
    output [31:0] ExtendedImm
    );

assign ExtendedImm = (EXTOp == `EXTOp_sign)?  {{16{Imm[15]}}, {Imm}} : 
                     (EXTOp == `EXTOp_zero)?          {16'b0, {Imm}} :
                     (EXTOp == `EXTOp_lui)?           {{Imm}, 16'b0} :
                     (EXTOp == `EXTOp_shamt)?       {27'b0, {shamt}} : 32'b0;
endmodule
