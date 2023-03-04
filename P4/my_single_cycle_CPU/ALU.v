`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:02:47 11/23/2021 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUControl,
    output [31:0] ALUResult
    );

assign ALUResult = (ALUControl == `ALU_add)? SrcA + SrcB :
				   (ALUControl == `ALU_sub)? SrcA - SrcB :
				   (ALUControl == `ALU_and)? SrcA & SrcB :
				   (ALUControl == `ALU_or)?  SrcA | SrcB :
				   (ALUControl == `ALU_sll)? SrcA << SrcB :
				   (ALUControl == `ALU_srl)? SrcA >> SrcB :
				   (ALUControl == `ALU_sra)? SrcA >>> SrcB :
				   (ALUControl == `ALU_xor)? SrcA ^ SrcB : 32'b0;

endmodule
