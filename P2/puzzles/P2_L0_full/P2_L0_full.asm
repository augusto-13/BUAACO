.data:
symbol: 	.space		32
array:		.space		32
str_space: 	.asciiz		" "
str_enter:	.asciiz		"\n"

.text:
li		$t4, 4
li		$v0, 5
syscall

move		$s0, $v0
li		$a0, 0

jal		FullArray	# FullArray( $a0<0> )

li		$v0, 10		# end
syscall	

FullArray:

if_1:
blt		$a0, $s0, else_1
li		$t0, 0			# Johnson³£Íü
for_1:
beq		$t0, $s0, for_1_end

li		$v0, 1			# print array[i]
mult		$t0, $t4
mflo		$t1
lw		$a0, array($t1)
syscall

la		$a0, str_space		# print space
li		$v0, 4
syscall

addi		$t0, $t0, 1		# i = i + 1
j		for_1

for_1_end:
la		$a0, str_enter		# print enter
li		$v0, 4
syscall
jr		$ra

#else
else_1:
li		$t0, 0
for_2:
beq		$t0, $s0, for_2_end
if_2:
mult		$t0, $t4
mflo		$t1
lw		$t2, symbol($t1)	# $t2 -> symbol[i]
bne		$t2, $0, else_2	# if(symbol[i] != 0) jump to else_2
addi		$t2, $t0, 1		# $t2 -> i + 1
mult		$a0, $t4
mflo		$t1
sw		$t2, array($t1)		# array[index] = i + 1
li		$t2, 1
mult		$t0, $t4
mflo		$t1
sw		$t2, symbol($t1)	# symbol[i] = 1

sw		$ra, 0($sp)
addi		$sp, $sp, -4
sw		$a0, 0($sp)
addi		$sp, $sp, -4
sw		$t0, 0($sp)
addi		$sp, $sp, -4

addi		$a0, $a0, 1
jal		FullArray

addi		$sp, $sp, 4
lw		$t0, 0($sp)
addi		$sp, $sp, 4
lw		$a0, 0($sp)
addi		$sp, $sp, 4
lw		$ra, 0($sp)

li		$t2, 0
mult		$t0, $t4
mflo		$t1
sw		$t2, symbol($t1)	# symbol[i] = 0

addi		$t0, $t0, 1		# i = i + 1
j		for_2

else_2:
addi		$t0, $t0, 1		# i = i + 1
j		for_2
	
for_2_end:
li		$t0, 0
jr		$ra		
