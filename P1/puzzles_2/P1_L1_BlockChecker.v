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
parameter s0  = 12'b0000_0000_0001,
          s1  = 12'b0000_0000_0010,
          s2  = 12'b0000_0000_0100,
          s3  = 12'b0000_0000_1000,
          s4  = 12'b0000_0001_0000,
          s5  = 12'b0000_0010_0000,
          s6  = 12'b0000_0100_0000,
          s7  = 12'b0000_1000_0000,
          s8  = 12'b0001_0000_0000,
          s9  = 12'b0010_0000_0000,
          s10 = 12'b0100_0000_0000,
          s11 = 12'b1000_0000_0000;

reg [31:0] MatchReg = 32'b1;
reg [11:0] state = s0;

always@(posedge clk, posedge reset) begin
    if(reset) begin
        MatchReg <= 32'b1;
        state <= s0;
    end
    else begin
        case(state)
            s0: begin
                if(MatchReg == 0)
                state <= s0;
                else begin
                if(in == "b" || in == "B") 
                state <= s1;
                else if(in == "e" || in == "E") 
                state <= s8;
                else if(in == " ")
                state <= s0;
                else
                state <= s7;
                end
            end
            s1: begin
                if(in == "e" || in == "E") 
                state <= s2;
                else if(in == " ")
                state <= s0;
                else
                state <= s7;
            end 
            s2: begin
                if(in == "g" || in == "G") 
                state <= s3;
                else if(in == " ")
                state <= s0;
                else
                state <= s7;
            end
            s3: begin
                if(in == "i" || in == "I") 
                state <= s4
                else if(in == " ")
                state <= s0;
                else
                state <= s7;
            end
            s4: begin
                if(in == "n" || in == "N") begin
                state <= s5;
                MatchReg <= MatchReg + 1;
                end
                else if(in == " ")
                state <= s0;
                else
                state <= s7;
            end
            s5: begin
                if(in == " ")
                state <= s0;
                else begin
                state <= s6;
                MatchReg <= MatchReg - 1;
                end
            end
            s6: begin
                if(in == " ")
                state <= s0;
                else
                state <= s7;
            end
            s7: begin
                if(in == " ")
                state <= s0;
                else
                state <= s7;
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

assign  output = (MatchReg == 32'b1);
endmodule
