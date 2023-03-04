`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:49:45 11/23/2021 
// Design Name: 
// Module Name:    BranchIf 
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
module BranchIf(
    input beq,
    input bne,
    input bgtz,
    input bltz,
    input [31:0] RD1_rs,
    input [31:0] RD2_rt,
    output BranchtoJump
    );

assign BranchtoJump = (beq && RD1_rs == RD2_rt)? 1 :
                      (bne && RD1_rs != RD2_rt)? 1 :
                      (bgtz && ($signed(RD1_rs) > $signed(32'b0)))? 1 :
                      (bltz && ($signed(RD1_rs) < $signed(32'b0)))? 1 : 0;

// $signed() !!!!!!

endmodule
