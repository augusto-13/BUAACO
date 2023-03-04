ori $s1, 0x33f0
sw  $s1, 0($0)

lw $2, 0($0)
ori $1, $2, 123
ori $1, $2, 321
ori $1, $2, 245
ori $1, $2, 1234

lw $3, 0($0)
beq $3, $1, label50 
nop
beq $3, $1, label50 
nop
beq $3, $1, label50
nop
beq $3, $1, label50
nop
label50: nop
lw $4, 0($0)
sw $4, 0x2000($0)
sw $4, 0x2004($0)
sw $4, 0x2008($0)
sw $4, 0x200c($0)