`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:40:18 11/23/2021 
// Design Name: 
// Module Name:    DM 
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
module M_DM(
    input  [31:0] PC, // Requirement
    input  clk,
    input  reset,
    input  [31:0] A,
    input  [31:0] WD,
    input  we,
	input  [2:0] DMType,
    output [31:0] RD
    );
reg [31:0] DataMemory [3071:0];
wire [11:0] waddr = A[13:2];
integer i;

/*
integer j;
integer temp;
always@(*) begin
	temp = 0;
	for(j = 0; j < 8; j = j + 1)
	temp = temp + DataMemory[waddr][8 * A[1:0] + j];
end
//bloez
*/

assign RD   =  	(DMType == `DMType_word)?  																	DataMemory[waddr] :
				(DMType == `DMType_half)? 	  {{16{DataMemory[waddr][16 * A[1] + 15]}},{DataMemory[waddr][16 * A[1]  +: 16]}} :
				(DMType == `DMType_byte)? 	{{24{DataMemory[waddr][8 *  A[1:0] + 7 ]}},{DataMemory[waddr][8 * A[1:0] +:  8]}} :
				(DMType == `DMType_halfu)? 	                                 	{16'b0,{DataMemory[waddr][16 * A[1]  +: 16]}} :
				(DMType == `DMType_byteu)? 	                                 	{24'b0,{DataMemory[waddr][8 * A[1:0] +:  8]}} :  DataMemory[waddr];

always@(posedge clk) begin
	if(reset) begin
		for(i = 0; i < 3072; i = i + 1)
		DataMemory[i] <= 32'b0;
	end
	else begin
		if(we) begin
			case(DMType)
				`DMType_word: begin
                    DataMemory[waddr]  <=  WD;
							$display("%d@%h: *%h <= %h", $time, PC, A, WD);
                end
				`DMType_half: begin
                    DataMemory[waddr][16 * A[1] +: 16]  <=  WD[15:0];       
					    case(A[1])
					    1'b0: begin
				   			$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{DataMemory[waddr][31:16]},{WD[15:0]}});
					    end
						/*1'b1*/
					    default: begin
				   			$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{WD[15:0]},{DataMemory[waddr][15:0]}});
					    end
					    endcase
                end
				`DMType_byte: begin
                    DataMemory[waddr][8 * A[1 : 0] +: 8]  <=  WD[7:0];
					    case(A[1:0])
					    2'b00: begin
					  		$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{DataMemory[waddr][31 : 8]},{WD[7 : 0]}});
					    end
					    2'b01: begin
					  		$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{DataMemory[waddr][31 : 16]},{WD[7 : 0]},{DataMemory[waddr][7 : 0]}});
					    end
					    2'b10: begin
					  		$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{DataMemory[waddr][31 : 24]},{WD[7 : 0]},{DataMemory[waddr][15 : 0]}});
					    end
						/*2'b11*/
					    default: begin
					  		$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{WD[7:0]},{DataMemory[waddr][23 : 0]}});
					    end
					    endcase
                end
				`DMType_swl: begin
						case(A[1:0])
						2'b00: begin
							DataMemory[waddr][7 : 0] <= WD[31 : 24];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{DataMemory[waddr][31 : 8]},{WD[31 : 24]}});
						end
						2'b01: begin
							DataMemory[waddr][15 : 0] <= WD[31 : 16];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{DataMemory[waddr][31 : 16]},{WD[31 : 16]}});
						end
						2'b10: begin
							DataMemory[waddr][23 : 0] <= WD[31 : 8];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{DataMemory[waddr][31 : 24]},{WD[31 : 8]}});
						end
						/*2'b11*/
						default: begin
							DataMemory[waddr] <= WD[31 : 0];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, WD[31 : 0]);
						end
						endcase
				end
				`DMType_swr: begin
						case(A[1:0])
						2'b00: begin
							DataMemory[waddr] <= WD[31 : 0];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, WD[31 : 0]);
						end
						2'b01: begin
							DataMemory[waddr][31 : 8] <= WD[23 : 0];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{WD[23 : 0]}, {DataMemory[waddr][7 : 0]}});
						end
						2'b10: begin
							DataMemory[waddr][31 : 16] <= WD[15 : 0];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{WD[15 : 0]}, {DataMemory[waddr][15 : 0]}});
						end
						/*2'b11*/
						default: begin
							DataMemory[waddr][31 : 24] <= WD[7 : 0];
							$display("%d@%h: *%h <= %h", $time, PC, {{A[31 : 2]}, {2'b00}}, {{WD[ 7 : 0]}, {DataMemory[waddr][23 : 0]}});
						end
						endcase
				end
				     default: ;
			endcase
		end
	   else ;
	end
end

endmodule

