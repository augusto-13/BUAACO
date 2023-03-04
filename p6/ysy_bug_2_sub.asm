TAG43:
multu $4, $4
lui $1, 8
xor $3, $1, $1
mult $1, $1
TAG44:
addiu $3, $3, 3
div $3, $3
mtlo $3
beq $3, $3, TAG45
TAG45:
mflo $1
mflo $3
lui $2, 0
xor $3, $2, $2
TAG46:
lh $1, 0($3)
or $1, $1, $1