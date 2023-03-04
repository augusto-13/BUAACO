.text:
li	$v0, 5
syscall
move	$s0, $v0
move	$a0, $s0

jal 	Factorial

move	$a0, $v0
li	$v0, 1
syscall
li	$v0, 10
syscall

Factorial:
if:
bne 	$a0, 1, else
li	$v0, 1			# if(n == 1)  $v0 -> 1
jr	$ra

else:
sw	$a0, 0($sp)
addi	$sp, $sp, -4
sw	$ra, 0($sp)
addi	$sp, $sp, -4

addi	$a0, $a0, -1		# factorial(* n - 1 *)
jal	Factorial

addi	$sp, $sp, 4
lw	$ra, 0($sp)
addi	$sp, $sp, 4
lw	$a0, 0($sp)
mult	$v0, $a0
mflo	$v0
jr	$ra