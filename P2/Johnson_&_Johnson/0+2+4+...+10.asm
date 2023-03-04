li 		$s0, 40
li		$t0, 0
li		$v0, 0 
in:
bgt 		$t0, $s0, out
add		$v0, $v0, $t0
addi		$t0, $t0, 2
j		in

out:
li		$t0, 0
move		$a0, $v0
li		$v0, 1
syscall

li		$v0, 10
syscall

