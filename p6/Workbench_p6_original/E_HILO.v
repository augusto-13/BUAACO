`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:19 12/23/2021 
// Design Name: 
// Module Name:    E_HILO 
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
module E_HILO(
    input clk,
    input reset,
    input [31:0] A_rs,
    input [31:0] B_rt,
    input [4:0] HILOType,
    output HILObusy,
    output [31:0] HILOResult
    );
reg [4:0] state;
reg [31:0] temp_hi, temp_lo, hi, lo;
reg  busy;
wire is_div   = (HILOType == `HILOType_div  )?  1 : 0;
wire is_divu  = (HILOType == `HILOType_divu )?  1 : 0;
wire is_mult  = (HILOType == `HILOType_mult )?  1 : 0;
wire is_multu = (HILOType == `HILOType_multu)?  1 : 0;
wire is_mthi  = (HILOType == `HILOType_mthi )?  1 : 0;
wire is_mtlo  = (HILOType == `HILOType_mtlo )?  1 : 0;
wire is_mfhi  = (HILOType == `HILOType_mfhi )?  1 : 0;
wire is_mflo  = (HILOType == `HILOType_mflo )?  1 : 0;
wire start = is_div | is_divu | is_mult | is_multu;
assign HILObusy = start | busy;
assign HILOResult = (is_mflo)? lo : (is_mfhi)? hi : 32'b0;
    always@(posedge clk) begin
        if(reset) begin
            busy <= 0;
            hi <= 0;
            lo <= 0;
            state <= 0;
        end
        else if(start && !busy && state == 0) begin
            if(is_mult) begin
                state <= 5;
                busy <= 1;
                {temp_hi, temp_lo} <= $signed(A_rs) * $signed(B_rt);
            end
            else if(is_multu) begin
                state <= 5;
                busy <= 1;
                {temp_hi, temp_lo} <= A_rs * B_rt;
            end
            else if(is_div) begin
                state <= 10;
                busy <= 1;
                temp_hi <= $signed(A_rs) % $signed(B_rt);
                temp_lo <= $signed(A_rs) / $signed(B_rt);
            end
            else if(is_divu) begin
                state <= 10;
                busy <= 1;
                temp_hi <= A_rs % B_rt;
                temp_lo <= A_rs / B_rt;
            end
            else ;
        end
        else if(!start && !busy && state == 0) begin
            if(is_mthi) begin
                hi <= A_rs;
                state <= 0;
                busy <= 0;
            end
            else if(is_mtlo) begin
                lo <= A_rs;
                state <= 0;
                busy <= 0;
            end   
            else ;  
        end
        else if(state > 1) begin
            state <= state - 1;
            busy <= 1;
        end
        else if(state == 1 && busy) begin
            hi <= temp_hi;
            lo <= temp_lo;
            busy <= 0;
            state <= 0;
        end
        else ;
    end 

endmodule
