`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:35:45 11/23/2021 
// Design Name: 
// Module Name:    GRF 
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
module D_GRF(
    input [31:0] PC, // Requirement
    input reset,
    input clk,
    input we,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
    );
integer i;
reg [31:0] RF [31:0];
assign RD1 = RF[A1];
assign RD2 = RF[A2];
always@(posedge clk) begin
	if(reset) begin
		for(i = 0; i < 32; i = i + 1)
		RF[i] <= 32'b0;
	end
	else begin
		if(we) begin
			if(A3 != 5'b0) begin
				RF[A3] <= WD3;
                $display("%d@%h: $%d <= %h", $time, PC, A3, WD3);
			end
            else RF[0] <= 32'b0;
		end
		else RF[0] <= 32'b0;
	end
end

endmodule
