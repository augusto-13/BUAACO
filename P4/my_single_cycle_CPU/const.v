// ALU.v
`define ALU_and 3'b000
`define ALU_or  3'b001
`define ALU_add 3'b010
`define ALU_sub 3'b011
`define ALU_srl 3'b100
`define ALU_sra 3'b101
`define ALU_sll 3'b110
`define ALU_xor 3'b111
// NPC.v
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
`define DMType_swl   3'b101
`define DMType_swr   3'b110