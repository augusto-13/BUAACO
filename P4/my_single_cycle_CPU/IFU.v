`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:38:00 11/23/2021 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
    input [31:0] PC_,
    input clk,
    input reset,
    output [31:0] Instr,
    output [5:0] Op,
    output [5:0] Funct,
    output [4:0] shamt,
    output [4:0] rd,
    output [4:0] rs,
    output [4:0] rt,
    output [15:0] Imm,
    output [25:0] addr,
    output reg [31:0] PC
    );

reg [31:0] IM [1023:0];
assign Instr = IM[PC[11:2]];

assign Op = Instr[31:26];
assign Funct = Instr[5:0];
assign shamt = Instr[10:6];
assign rd = Instr[15:11];
assign rt = Instr[20:16];
assign rs = Instr[25:21];
assign Imm = Instr[15:0];
assign addr = Instr[25:0];
	 
always@(posedge clk) begin
    if(reset) begin
        PC <= 32'h00003000; 
		  $readmemh("code.txt", IM);
		  $display("%h", IM[PC]);
    end
    else begin
        PC <= PC_;
    end
end
endmodule
