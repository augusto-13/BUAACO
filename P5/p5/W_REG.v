`include "const.v"
module W_REG (
    input clk,
    input reset,
    input WE,
    input [31:0] Instr_in,
    input [31:0] PC8_in,
    input [31:0] RD_in,
    input [31:0] ALUResult_in,
    output reg [31:0] Instr_out,
    output reg [31:0] PC8_out,
    output reg [31:0] RD_out,
    output reg [31:0] ALUResult_out
);

    always @(posedge clk) begin
        if (reset) begin
            Instr_out       <=       0;
            PC8_out         <=       0;
            RD_out          <=       0;
            ALUResult_out   <=       0;
        end else if(WE) begin
            Instr_out       <=       Instr_in;
            PC8_out         <=       PC8_in;
            RD_out          <=       RD_in;
            ALUResult_out   <=       ALUResult_in;
        end
    end

endmodule