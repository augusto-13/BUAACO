`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:25:43 12/14/2021 
// Design Name: 
// Module Name:    FU_FSU 
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
// 初始化时stall = x的问题根源究竟在哪里？
// stall赋值依赖于个流水线寄存器中存储的指令
// 而E级流水线的清零信号为stall
// 这就导致系统整体初始化清零时，E级流水线无法正常初始化，而是赋值为x
// 这也进一步导致stall的赋值会出现未知x
// 如此循环往复，互相伤害。戏称其为神奇的互锁现象。
// 打破恶性循环的重要方法，即保证E级流水线正常初始化清零。
module FSU(
	input W_lwso_yes
    input [31:0] FSU_DInstr,
    input [31:0] FSU_EInstr,
    input [31:0] FSU_MInstr,
    input [31:0] FSU_WInstr,
    output stall,
    output [1:0] FWMux_Ers_Sel,//3
    output [1:0] FWMux_Ert_Sel,//3
    output [1:0] FWMux_Drs_Sel,//4
    output [1:0] FWMux_Drt_Sel,//4
    output FWMux_Mrt_Sel //2
    );
wire [5:0] FSU_DInstrType, FSU_EInstrType, FSU_MInstrType, FSU_WInstrType;
wire [4:0] FSU_ERegDst, FSU_MRegDst, FSU_WRegDst; 
wire stall_rs, stall_rt, stall_rs_E, stall_rs_M, stall_rt_E, stall_rt_M;
wire [4:0] FSU_Drs, FSU_Drt, FSU_Ers, FSU_Ert, FSU_Mrs, FSU_Mrt, FSU_Wrs, FSU_Wrt;
Decoder FSU_DDecoder (
		.Instr(FSU_DInstr),  
		.rs(FSU_Drs), 
		.rt(FSU_Drt), 
		.InstrType(FSU_DInstrType)
	);

Decoder FSU_EDecoder (
		.Instr(FSU_EInstr),
		.rs(FSU_Ers),
		.rt(FSU_Ert), 
		.InstrType(FSU_EInstrType), 
		.RegDst(FSU_ERegDst)
	);

Decoder FSU_MDecoder (
		.Instr(FSU_MInstr),
		.rt(FSU_Mrt), 
		.InstrType(FSU_MInstrType), 
		.RegDst(FSU_MRegDst)
	);
// 暂停的目的：新进入流水线寄存器的指令在使用$k寄存器的数值时，$k寄存器对应最新数值仍未产生
// 因此需暂停D级流水线运行，保证指令在使用$k时，最新数值已经被计算出来
// 指令如果已经到达W级，暂停的行为是没有意义的
// 因为W_STAGE不包含计算类元件，最新计算结果不会在W_STAGE产生
// 因此，涉及暂停时，只需考虑E、M两级的Tnew
Decoder FSU_WDecoder (
		.Instr(FSU_WInstr),
		.InstrType(FSU_WInstrType), 
		.RegDst(FSU_WRegDst)
	);

// Tuse
wire [3:0] Tuse_rs = (FSU_DInstrType == `cal_R)?    4'd1 :
					 (FSU_DInstrType == `cal_Ist)?  4'd1 :
					 (FSU_DInstrType == `j_r)?	    4'd0 :
					 (FSU_DInstrType == `j_lr)?	    4'd0 :
					 (FSU_DInstrType == `store)?    4'd1 :
					 (FSU_DInstrType == `load)?	    4'd1 :
					 (FSU_DInstrType == `b_st)?	    4'd0 :
					 (FSU_DInstrType == `b_s)?	    4'd0 :
					 (FSU_DInstrType == `lwso)?	    4'd1 : `Tuse_inf;

wire [3:0] Tuse_rt = (FSU_DInstrType == `cal_R)?    4'd1 :
					 (FSU_DInstrType == `store)?    4'd2 :
					 (FSU_DInstrType == `b_st)?	    4'd0 : `Tuse_inf;

// Tnew
wire [3:0] E_Tnew  = (FSU_EInstrType == `cal_R)?    		 4'd1 :
					 (FSU_EInstrType == `cal_Ist)?  		 4'd1 :
					 (FSU_EInstrType == `j_l)?	    `Tnew_already :
					 (FSU_EInstrType == `j_lr)?	    `Tnew_already :
					 (FSU_EInstrType == `load)?     		 4'd2 :
					 (FSU_EInstrType == `lwso)?     		 4'd2 :
					 (FSU_EInstrType == `cal_It)?   		 4'd1 : `Tnew_already;
					 
wire [3:0] M_Tnew  = (FSU_MInstrType == `cal_R)?    `Tnew_already :
					 (FSU_MInstrType == `cal_Ist)?  `Tnew_already :
					 (FSU_MInstrType == `cal_It)?   `Tnew_already :
					 (FSU_MInstrType == `j_l)?	    `Tnew_already :
					 (FSU_MInstrType == `j_lr)?	    `Tnew_already :
					 (FSU_MInstrType == `load)?     		 4'd1 : 
					 (FSU_MInstrType == `lwso)?     		 4'd1 :`Tnew_already;

assign stall_rs_E = (Tuse_rs < E_Tnew) && (FSU_Drs == FSU_ERegDst) && (FSU_Drs != 0);
assign stall_rs_M = (Tuse_rs < M_Tnew) && (FSU_Drs == FSU_MRegDst) && (FSU_Drs != 0);
assign stall_rs = stall_rs_E || stall_rs_M;
assign stall_rt_E = (Tuse_rt < E_Tnew) && (FSU_Drt == FSU_ERegDst) && (FSU_Drt != 0);
assign stall_rt_M = (Tuse_rt < M_Tnew) && (FSU_Drt == FSU_MRegDst) && (FSU_Drt != 0);
assign stall_rt = stall_rt_E || stall_rt_M;
assign stall = (stall_rs || stall_rt);

// forward(from)
wire forwardW = (FSU_WInstrType == `cal_R) || (FSU_WInstrType == `cal_Ist) || (FSU_WInstrType == `cal_It) || (FSU_WInstrType == `load) || (FSU_WInstrType == `j_l) || (FSU_WInstrType == `j_lr) || (FSU_WInstrType == `lwso & W_lwso_yes);
wire forwardM = (FSU_MInstrType == `cal_R) || (FSU_MInstrType == `cal_Ist) || (FSU_MInstrType == `cal_It) || (FSU_MInstrType == `j_l)  || (FSU_MInstrType == `j_lr);
wire forwardE = (FSU_EInstrType == `j_l)   || (FSU_EInstrType == `j_lr);

assign FWMux_Mrt_Sel =  forwardW && (FSU_WRegDst == FSU_Mrt) && (FSU_Mrt != 0);
assign FWMux_Ers_Sel = (forwardM && (FSU_MRegDst == FSU_Ers) && (FSU_Ers != 0))? 2'b10 :
					   (forwardW && (FSU_WRegDst == FSU_Ers) && (FSU_Ers != 0))? 2'b01 : 2'b00;
assign FWMux_Ert_Sel = (forwardM && (FSU_MRegDst == FSU_Ert) && (FSU_Ert != 0))? 2'b10 :
					   (forwardW && (FSU_WRegDst == FSU_Ert) && (FSU_Ert != 0))? 2'b01 : 2'b00;
assign FWMux_Drs_Sel = (forwardE && (FSU_ERegDst == FSU_Drs) && (FSU_Drs != 0))? 2'b11 :
					   (forwardM && (FSU_MRegDst == FSU_Drs) && (FSU_Drs != 0))? 2'b10 :
					   (forwardW && (FSU_WRegDst == FSU_Drs) && (FSU_Drs != 0))? 2'b01 : 2'b00;
assign FWMux_Drt_Sel = (forwardE && (FSU_ERegDst == FSU_Drt) && (FSU_Drt != 0))? 2'b11 :
					   (forwardM && (FSU_MRegDst == FSU_Drt) && (FSU_Drt != 0))? 2'b10 :
					   (forwardW && (FSU_WRegDst == FSU_Drt) && (FSU_Drt != 0))? 2'b01 : 2'b00;
endmodule

// lui出了问题

// 错了错了！！
// 当指令为j_l时，应转PC(D_PC)+8，单独增加通道
// 注意，不要破坏转发优先级
// 在W级流水线寄存器对应条件前加~~~
// ---> 为不破坏源代码的美观
// ---> 在各级流水线寄存器后加一MUX，Result or PC+8 二选一，选择信号为“jal”（不要删！！！


