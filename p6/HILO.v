`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:00:17 11/26/2021 
// Design Name: 
// Module Name:    HILO 
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
module HILO(
input clk,
input reset,
input Start,
input [2:0] Op,
input HIWrite,
input LOWrite,
input [31:0] A,
input [31:0] B,
output Busy,
output reg [31:0] HIOut,
output reg [31:0] LOOut
);
parameter MULU = 3'b000, MUL = 3'b001, DIVU = 3'b010, DIV = 3'b011;
	
reg [31:0] HI, LO;
reg [3:0] cnt;

always @ (posedge clk) begin
	if (reset) begin
		HIOut <= 0;
		LOOut <= 0;
		HI <= 0;
		LO <= 0;
		cnt <= 0;
	end
	else if (Start) begin
		case (Op)
			MULU: begin
				{HI, LO} <= A * B;
				cnt = 5;
			end
			MUL: begin
				{HI, LO} <= $signed(A) * $signed(B);
				cnt = 5;
			end
			DIVU: begin
				LO <= A / B;
				HI <= A % B;
				cnt = 10;
			end
			DIV: begin
				LO <= $signed(A) / $signed(B);
				HI <= $signed(A) % $signed(B);
				cnt = 10;
			end
		endcase
	end
	else if (HIWrite) begin
		HIOut <= A;
	end
	else if (LOWrite) begin
		LOOut <= A;
	end
	if (reset == 0 && Start == 0 && cnt != 0) begin
		cnt <= cnt - 1;
	end
end
	
assign Busy = (cnt != 0);
	
always @ (negedge Busy) begin
	HIOut <= HI;
	LOOut <= LO;
end
endmodule
