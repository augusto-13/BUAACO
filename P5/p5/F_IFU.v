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
module F_IFU(
    input [31:0] PC_,
    input clk,
    input EN,
    input reset,
    output [31:0] Instr,
    output reg [31:0] PC
    );

reg [31:0] IM [4095:0];
assign Instr = IM[(PC[13:2]-12'hc00)];

always@(posedge clk) begin
    if(reset) begin
        PC <= 32'h00003000; 
		  $readmemh("code.txt", IM);
		  //$display("%h", IM[PC]);
    end
    else if(EN) begin
        PC <= PC_;
    end
end
endmodule
