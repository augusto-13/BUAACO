`include "const.v"
module D_REG (
    input clk,
    input reset,
    input WE,
    input [31:0] Instr_in,
    input [31:0] PC_in,
    output reg [31:0] Instr_out,
    output reg [31:0] PC_out
);

    always @(posedge clk) begin
        if (reset) begin
            Instr_out     <= 0;
            PC_out        <= 0;
        end else if(WE) begin
            Instr_out     <=  Instr_in;
            PC_out        <=  PC_in;
        end
    end

endmodule