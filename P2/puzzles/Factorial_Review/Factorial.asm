.text:
li		$v0, 5
syscall
move		$s0, $v0	# $s0 -> n
move		$a0, $s0	# $a0 -> n; n-1; n-2; ...; 1; 
				# $v0 -> 1; 1*2; 1*2*3; ...; 1*2*3*...*n
jal		factorial	# jal not j, later it will indicate the end of this program

move		$a0, $v0
li		$v0, 1
syscall
li		$v0, 10
syscall

factorial:
bne		$a0, 1, minus		# if($a0 != 1)  --->   $a0 = $a0 - 1
li		$v0, 1			# $v0 -> 1
jr		$ra			# used only once, for the purpose of jump to the 2nd part of the factorial
					# the last $ra is not saved in register, used directly herre!!!
minus:
sw		$ra, 0($sp)		# store $ra and $a0
subi		$sp, $sp, 4
sw		$a0, 0($sp)
subi		$sp, $sp, 4

addi		$a0, $a0, -1		# $a0 = $a0 - 1
jal		factorial		# Jump back to factorial and Link

addi		$sp, $sp, 4		# load $ra and $a0
lw		$a0, 0($sp)
addi		$sp, $sp, 4
lw		$ra, 0($sp)

mult		$v0, $a0		# $v0 = $v0 * $a0
mflo		$v0
jr		$ra			# keep retriving $a0 in stack && later go back to the top(end)



