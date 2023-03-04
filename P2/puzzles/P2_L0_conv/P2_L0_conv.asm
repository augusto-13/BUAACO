.data 
matrix_A:	.space		400	# 10 * 10 * 4 byte
matrix_B:	.space		400	# 10 * 10 * 4 byte
str_space: 	.asciiz		" "
str_enter:	.asciiz		"\n"

.macro getindex(%ans, %i, %j)		# ans = (i * 10 + j) * 4
	mul	%ans, %i, 10 
	add  	%ans, %ans, %j
	sll	%ans, %ans, 2
.end_macro 

.text
li 	$v0, 5			# read m1 -> $s0
syscall
move 	$s0, $v0

li 	$v0, 5			# read n1 -> $s1
syscall
move 	$s1, $v0

li 	$v0, 5			# read m2 -> $s2
syscall
move 	$s2, $v0

li 	$v0, 5			# read n2 -> $s3
syscall
move 	$s3, $v0

li 	$t0, 0			# i, j -> 0
li	$t1, 0

A_in_i:
beq 	$s0, $t0, A_in_i_end
li 	$t1, 0

A_in_j:
beq	$s1, $t1, A_in_j_end
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
beq 	$s2, $t0, B_in_i_end
li 	$t1, 0

B_in_j:
beq	$s3, $t1, B_in_j_end
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

# $s0 -> m1 - m2 + 1;  $s1 -> n1 - n2 + 1
sub  	$s0, $s0, $s2
addi	$s0, $s0, 1
sub  	$s1, $s1, $s3
addi	$s1, $s1, 1

out_i:
beq	$t0, $s0, out_i_end
li	$t1, 0			# j -> 0

out_j:
beq	$t1, $s1, out_j_end
li	$a0, 0			# $a0 -> ans
li	$t2, 0			# $t2 -> k, k -> 0

out_k:
beq	$t2, $s2, out_k_end
li	$t3, 0			# l -> 0

out_l:
beq	$t3, $s3, out_l_end		# if k == n, the end of k_loop
add	$t4, $t0, $t2			# $t4 -> i + k
add	$t5, $t1, $t3			# $t5 -> j + l
getindex($t4 ,$t4, $t5)		# $t4 -> [i+k][j+l]_index
getindex($t5, $t2, $t3)		# $t5 -> [k][l]_index
lw	$t4, matrix_A($t4)		# $t4 -> [i+k][j+l]
lw	$t5, matrix_B($t5) 		# $t5 -> [k][l]
mult	$t4, $t5
mflo 	$t4				# $t4 = $t4 * $t5
add	$a0, $a0, $t4			# ans = ans + $t4
addi	$t3, $t3, 1			# l = l + 1
j	out_l

out_l_end:
addi 	$t2, $t2, 1
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
