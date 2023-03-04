.data:
string: 	.space		20

.text:
li	$v0, 5
syscall
move 	$s0, $v0		# $read n -> $s0
 
li	$t0, 2			# borrow $t0 for 2
div  	$s0, $t0
mflo	$s1			# n/2 -> $s1	

li	$t0, 0			# $t0 -> i = 0

while:
beq 	$t0, $s0, while_end

li	$v0, 12
syscall
sb 	$v0, string($t0)	# getchar -> a[i]

addi	$t0, $t0, 1		# i = i + 1
j	while

while_end:
li	$t0, 0

in_i:
beq	$t0, $s1, out_i_1
subi	$t1, $s0, 1
sub	$t1, $t1, $t0		# $t1 -> n - 1 - i
lbu 	$t1, string($t1)	# $t1 -> [n-1-i]
lbu	$t2, string($t0)	# $t2 -> [i]
bne	$t1, $t2, out_i_0	# if ([i] != [n-1-i])  jump to out_i_0
addi	$t0, $t0, 1		# i = i + 1
j	in_i			


out_i_0:
li	$a0, 0
li	$v0, 1
syscall
li	$v0, 10
syscall

out_i_1:
li	$a0, 1
li	$v0, 1
syscall
li	$v0, 10
syscall








