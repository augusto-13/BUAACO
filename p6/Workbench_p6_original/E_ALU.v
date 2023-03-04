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

module E_ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [3:0] ALUControl,
    output [31:0] ALUResult
    );
wire [31:0] slt_result  = ($signed(SrcA) < $signed(SrcB))?    32'b1 : 32'b0;
wire [31:0] sltu_result = (SrcA < SrcB)?                      32'b1 : 32'b0;
assign ALUResult =  (ALUControl == `ALU_add)?                               SrcA + SrcB :
                    (ALUControl == `ALU_sub)?                               SrcA - SrcB :
                    (ALUControl == `ALU_and)?                               SrcA & SrcB :
                    (ALUControl == `ALU_or)?                                SrcA | SrcB :
                    (ALUControl == `ALU_xor)?                               SrcA ^ SrcB : 
                    (ALUControl == `ALU_nor)?                         ~ ( SrcA | SrcB ) :
                    (ALUControl == `ALU_slt)?                                slt_result : 
                    (ALUControl == `ALU_sltu)?                              sltu_result :
                    (ALUControl == `ALU_sll)?                       SrcA << (SrcB[4:0]) :
                    (ALUControl == `ALU_srl)?                       SrcA >> (SrcB[4:0]) :
                    (ALUControl == `ALU_sra)?      $signed($signed(SrcA) >>> SrcB[4:0]) : 32'b0;

endmodule
