`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:09:28 11/03/2021
// Design Name:   BlockChecker
// Module Name:   E:/ise/p1/P1_2/Blockchecker_tb.v
// Project Name:  P1_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BlockChecker
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Blockchecker_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] in;

	// Outputs
	wire result;

	// Instantiate the Unit Under Test (UUT)
	BlockChecker uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		in = "a";
		#2;
		reset = 0;
		#8;
		in = " ";
		#10;
		in = "B";
		#10;
		in = "e";
		#10;
		in = "g";
		#10;
		in = "i";
		#10;
		in = "N";
		#10;
		in = " ";
		#10;
		in = "e";
		#10;
		in = "n";
		#10;
		in = "D";
		#10;
		in = "c";
		#10;
		in = " ";
		#10;
		in = "e";
		#10;
		in = "n";
		#10;
		in = "d";
		#10;
		in = " ";
		#10;
		in = "e";
		#10;
		in = "n";
		#10;
		in = "d";
		#10;
		in = " ";
		#10;
		in = "B";
		#10;
		in = "e";
		#10;
		in = "g";
		#10;
		in = "i";
		#10;
		in = "N";
		#10;
		in = " ";
        
		// Add stimulus here

	end
   
	always #10 clk = ~clk;
endmodule

