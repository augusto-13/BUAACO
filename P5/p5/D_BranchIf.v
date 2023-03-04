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
`include "const.v"
module D_BranchIf(
    input [2:0] BType,
    input [31:0] RD1rs,
    input [31:0] RD2rt,
    output BranchtoJump
    );
    
wire beq = (BType == `BType_beq);
wire bne = (BType == `BType_bne);
wire bgtz = (BType == `BType_bgtz);
wire bltz = (BType == `BType_bltz);
wire bgez = (BType == `BType_bgez);
wire blez = (BType == `BType_blez);

assign BranchtoJump = (beq && RD1rs == RD2rt)? 1 :
                      (bne && RD1rs != RD2rt)? 1 :
                      (bgtz && ($signed(RD1rs) > $signed(32'b0)))?   1 :
                      (bltz && ($signed(RD1rs) < $signed(32'b0)))?   1 :
                      (bgez && ($signed(RD1rs) >= $signed(32'b0)))?  1 :
                      (blez && ($signed(RD1rs) <= $signed(32'b0)))?  1 : 0;

// $signed() !!!!!!

endmodule
