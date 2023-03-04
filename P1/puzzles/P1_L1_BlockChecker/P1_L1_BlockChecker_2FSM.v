`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:29:21 10/25/2021 
// Design Name: 
// Module Name:    BlockChecker 
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
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );

parameter s0  = 12'b000000000001,
          s1  = 12'b000000000010,
          s2  = 12'b000000000100,
          s3  = 12'b000000001000,
          s4  = 12'b000000010000,
          s5  = 12'b000000100000,
          s6  = 12'b000001000000,
          s7  = 12'b000010000000,
          s8  = 12'b000100000000,
          s9  = 12'b001000000000,
          s10 = 12'b010000000000,
          s11 = 12'b100000000000;

reg [31:0] MatchReg = 32'b1;
reg [11:0] state = s0;

always@(posedge clk, posedge reset) begin
    if(reset) begin
        state <= s0;
        MatchReg <= 32'b1;
    end
    else begin
        case(state) 
            s0: begin
                if(MatchReg == 0) begin
                    state <= s0;
                end
                else begin
                    if(in == " ") state <= s0;
                    else if(in == "b" || in == "B") state <= s1;
                    else if(in == "e" || in == "E") state <= s8;
                    else state <= s7;
                end
        end 
            s1: begin
                if(in == " ") state <= s0;
                else if(in == "e" || in == "E") state <= s2;
                else state <= s7;
            end
            s2: begin
                if(in == " ") state <= s0;
                else if(in == "g" || in == "G") state <= s3;
                else state <= s7;
            end
            s3: begin
                if(in == " ") state <= s0;
                else if(in == "i" || in == "I") state <= s4;
                else state <= s7;
            end
            s4: begin
                if(in == " ") state <= s0;
                else if(in == "n" || in == "N") begin 
                    state <= s5;
                    MatchReg <= MatchReg + 1;
                end 
                else state <= s7;
            end
            s5: begin
                if(in == " ") state <= s0;
                else begin 
                    state <= s6;
                    MatchReg <= MatchReg - 1;
                end 
            end
            s6: begin
                if(in == " ") state <= s0;
                else state <= s7;
            end
            s7: begin
                if(in == " ") state <= s0;
                else state <= s7;
            end
            s8: begin
                if(in == " ") state <= s0;
                else if(in == "n" || in == "N") state <= s9;
                else state <= s7;
            end
            s9: begin
                if(in == " ") state <= s0;
                else if(in == "d" || in == "D") begin 
                    state <= s10;
                    MatchReg <= MatchReg - 1;
                end 
                else state <= s7;
            end
            s10: begin
                if(in == " ") state <= s0;
                else begin 
                    state <= s11;
                    MatchReg <= MatchReg + 1;
                end 
            end
            s11: begin
                if(in == " ") state <= s0;
                else state <= s7;
            end
        endcase
    end 
end

assign result = (MatchReg == 32'b1);

endmodule
