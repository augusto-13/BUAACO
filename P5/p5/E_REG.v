`include "const.v"
module E_REG (
    input clk,
    input reset,
    input WE,
    input [31:0] Instr_in,
    input [31:0] PC8_in,
    input [31:0] FWRD1_in,
    input [31:0] FWRD2_in,
    input [31:0] ExtendedImm_in,
    output reg [31:0] Instr_out,
    output reg [31:0] PC8_out,
    output reg [31:0] FWRD1_out,
    output reg [31:0] FWRD2_out,
    output reg [31:0] ExtendedImm_out
);

    always @(posedge clk) begin
        if (reset) begin
            Instr_out       <=       0;
            PC8_out         <=       0;
            FWRD1_out       <=       0;
            FWRD2_out       <=       0;
            ExtendedImm_out <=       0;
        end else if(WE) begin
            Instr_out       <=   Instr_in;
            PC8_out         <=   PC8_in;
            FWRD1_out       <=   FWRD1_in;
            FWRD2_out       <=   FWRD2_in;
            ExtendedImm_out <=   ExtendedImm_in;
        end
    end

endmodule