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
    output reg [31:0] PC
    );

always@(posedge clk) begin
    if(reset) begin
        PC <= 32'h00003000;
    end
    else if(EN) begin
        PC <= PC_;
    end
end
endmodule
