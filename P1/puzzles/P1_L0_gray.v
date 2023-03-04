`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:38:12 10/23/2021 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output Overflow
    );
    
reg [2:0] OutputReg = 3'b000;
reg OverflowReg = 0;
always@(posedge Clk) begin
    if (Reset == 1) begin
        OutputReg <= 3'b000;
        OverflowReg <= 1'b0;
    end
    else begin
        if(En == 1) begin
            case (OutputReg) 
                3'b000: begin
                    OutputReg <= 3'b001;
                end
                3'b001: begin
                    OutputReg <= 3'b011;
                end
                3'b011: begin
                    OutputReg <= 3'b010;
                end
                3'b010: begin
                    OutputReg <= 3'b110;
                end
                3'b110: begin
                    OutputReg <= 3'b111;
                end
                3'b111: begin
                    OutputReg <= 3'b101;
                end
                3'b101: begin
                    OutputReg <= 3'b100;
                end
                3'b100: begin
                    OutputReg <= 3'b000;
                    OverflowReg <= 1'b1;
                end
                default: ;
            endcase
        end
    end
end

assign Output = OutputReg;
assign Overflow = OverflowReg;

endmodule
