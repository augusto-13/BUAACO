.data 
matrix_A:	.space		256	# 8 * 8 * 4 byte
matrix_B:	.space		256	# 8 * 8 * 4 byte
str_space: 	.asciiz		" "
str_enter:	.asciiz		"\n"

.macro getindex(%ans, %i, %j)		# ans = (i * 8 + j) * 4
	sll 	%ans, %i, 3
	add  	%ans, %ans, %j
	sll	%ans, %ans, 2
.end_macro 

.text
li 	$v0, 5			# read n -> $s0
syscall
move 	$s0, $v0

li 	$t0, 0			# i, j -> 0
li	$t1, 0

A_in_i:
beq 	$s0, $t0, A_in_i_end
li 	$t1, 0

A_in_j:
beq	$s0, $t1, A_in_j_end
li 	$v0, 5			# read [i][j] -> $v0
syscall
getindex($t2, $t0, $t1)	# $t2 -> matrix + <imm>
sw	$v0, matrix_A($t2)
addi 	$t1, $t1, 1
j	A_in_j

A_in_j_end:
addi 	$t0, $t0, 1
j	 A_in_i

A_in_i_end:
li	$t0, 0

B_in_i:
beq 	$s0, $t0, B_in_i_end
li 	$t1, 0

B_in_j:
beq	$s0, $t1, B_in_j_end
li 	$v0, 5			# read [i][j] -> $v0
syscall
getindex($t2, $t0, $t1)	# $t2 -> matrix + <imm>
sw	$v0, matrix_B($t2)
addi 	$t1, $t1, 1
j	B_in_j

B_in_j_end:
addi 	$t0, $t0, 1
j	 B_in_i

B_in_i_end:
li	$t0, 0

out_i:
beq	$t0, $s0, out_i_end
li	$t1, 0			# j -> 0

out_j:
beq	$t1, $s0, out_j_end
li	$a0, 0		# $a0 -> ans
li	$t2, 0			# $t2 -> k, k -> 0

out_k:
beq	$t2, $s0, out_k_end		# if k == n, the end of k_loop
getindex($t3 ,$t0, $t2)		# $t3 -> [i][k]_index
getindex($t4, $t2, $t1)		# $t4 -> [k][j]_index
lw	$t3, matrix_A($t3)		# $t3 -> [i][k]
lw	$t4,,matrix_B($t4) 		# $t4 -> [k][j]
mult	$t3, $t4
mflo 	$t3				# $t3 = $t3 * $t4
add	$a0, $a0, $t3			# ans = ans + $t3
addi	$t2, $t2, 1			# k = k + 1
j	out_k

out_k_end:
addi	$t1, $t1, 1			# j = j + 1

li	$v0, 1				# print ans
syscall

la	$a0, str_space			# print " "
li	$v0, 4
syscall

j 	out_j				# go to the start of j

out_j_end:
la	$a0, str_enter			# print "\n"
li	$v0, 4
syscall
addi	$t0, $t0, 1			# i = i + 1
j	out_i				# go to the start of i

out_i_end:
li	$t0, 0				# i = 0

li 	$v0, 10				# end the program
syscall


