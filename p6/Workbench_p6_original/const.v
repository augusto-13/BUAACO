// 安全的编码方式：
// 预留0信号，不符合其他分支时使用
// 即：一但分支条件都不满足，即将信号置零

// ALU.v
`define ALU_and  4'b0000
`define ALU_or   4'b0001
`define ALU_add  4'b0010
`define ALU_sub  4'b0011
`define ALU_srl  4'b0100
`define ALU_sra  4'b0101
`define ALU_sll  4'b0110
`define ALU_xor  4'b0111
`define ALU_nor  4'b1000
`define ALU_slt  4'b1001
`define ALU_sltu 4'b1010
`define ALU_null 4'b1111
// CMP.v
`define BType_notb 3'b000
`define BType_bne  3'b001
`define BType_bgtz 3'b010
`define BType_bltz 3'b011
`define BType_bgez 3'b100
`define BType_blez 3'b101
`define BType_beq  3'b110
// NPC.v
`define JumpOp_notj 3'b000
`define JumpOp_jal  3'b001
`define JumpOp_j    3'b010
`define JumpOp_jr   3'b011
`define JumpOp_jalr 3'b100
// DM.v
`define DMType_word  3'b000
`define DMType_half  3'b001
`define DMType_byte  3'b010
`define DMType_byteu 3'b011
`define DMType_halfu 3'b100
`define DMType_null  3'b111
// EXT.v
`define EXTOp_zero   3'b000
`define EXTOp_sign   3'b001
`define EXTOp_lui    3'b010
`define EXTOp_shamt  3'b011 
`define EXTOp_null   3'b111
// InstrType
`define InstrType_error 6'b111111
`define cal_R           6'd0
`define cal_Ist         6'd1
`define j_addr          6'd2
`define j_l             6'd3
`define j_r             6'd4
`define store           6'd5
`define load            6'd6
`define b_st            6'd7
`define b_s             6'd8
`define hilo            6'd9
`define cal_It          6'd10
`define j_lr            6'd11
`define shift_R         6'd12
`define syscall         6'd13
`define hilo_cal        6'd14
`define hilo_mf         6'd15
`define hilo_mt         6'd16
// T_use
`define Tuse_inf     4'd5
`define Tnew_already 4'd0
// ALUSrc[1:0]
`define ALUSrc_Imm     2'b00
`define ALUSrc_rt      2'b01
`define ALUSrc_rs      2'b10
// HILO.v [4:0]
`define HILOType_div   5'd0
`define HILOType_divu  5'd1
`define HILOType_mult  5'd2
`define HILOType_multu 5'd3
`define HILOType_mfhi  5'd4
`define HILOType_mflo  5'd5
`define HILOType_mthi  5'd6
`define HILOType_mtlo  5'd7
`define HILOType_error 5'd8
// MUX_ALUorHILO
`define MUX_ALU   1'b0
`define MUX_HILO  1'b1