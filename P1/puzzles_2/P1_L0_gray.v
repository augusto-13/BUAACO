`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:02 11/03/2021 
// Design Name: 
// Module Name:    P1_L0_gray 
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
module P1_L0_gray(
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output Overflow
    );
reg  [2:0]  Output_Reg = 3'b0;
reg         Overflow_Reg = 1'b0;
always@(posedge Clk) begin
    if(Reset) begin
        Output_Reg <= 3'b0;
        Overflow_Reg <= 1'b0;
    end
    else begin
       if(En) begin
           case (Output)
                3'b000: begin
                    Output_Reg <= 3'b001;
                end
                3'b001: begin
                    Output_Reg <= 3'b011;
                end
                3'b011: begin
                    Output_Reg <= 3'b010;
                end
                3'b010: begin
                    Output_Reg <= 3'b110;
                end
                3'b110: begin
                    Output_Reg <= 3'b111;
                end
                3'b111: begin
                    Output_Reg <= 3'b101;
                end
                3'b101: begin
                    Output_Reg <= 3'b100;
                end
                3'b100: begin
                    Output_Reg <= 3'b000;
                    Overflow_Reg <= 1'b1;
                end
                default: 
           endcase
       end 
    end
end 

assign  Output = Output_Reg;
assign  Overflow = Overflow_Reg;

endmodule
