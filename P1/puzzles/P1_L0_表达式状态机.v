`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:22 10/23/2021 
// Design Name: 
// Module Name:    string 
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
module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );

parameter  s0 = 4'b0001,
           s1 = 4'b0010,
           s2 = 4'b0100,
           s3 = 4'b1000;

reg [3:0] state = s0;
wire isdigit = (in >= "0" && in <= "9") ? 1 : 0 ; 

always@(posedge clk, posedge clr) begin
    if(clr) begin
        state <= s0;
    end
    else begin
    case(state)
    s0: begin
        state <= (isdigit) ? s1 : s3;
    end
    s1: begin
        state <= (isdigit) ? s3 : s2;
    end
    s2: begin
        state <= (isdigit) ? s1 : s3;
    end
    s3: begin
        state <= s3;
    end
    default: ;
    endcase
    end
end

assign out = (state == s1);
endmodule
