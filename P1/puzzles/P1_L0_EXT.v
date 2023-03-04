`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:52 10/23/2021 
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
module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output [31:0] ext
    );

    assign ext = (EOp == 2'b00) ? {{16{imm[15]}} , imm[15:0]} :
                 (EOp == 2'b01) ? {{16{0}} , imm[15:0]} :
                 (EOp == 2'b10) ? {imm[15:0] , {16{0}}} :
                 (EOp == 2'b11) ? $signed($signed({{16{imm[15]}} , imm[15:0]}) << 2) : 32'b0 ;
endmodule
