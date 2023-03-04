.macro getindex_2(%ans, %i, %j)
sll	%ans, %i, 3		# ans = i * 8
add	%ans, %ans, %j		# ans = i * 8 + j
sll	%ans, %ans, 2		# ans = 4 * (i * 8 + j)
.end_macro

.macro PI(%n)
move	$a0, %n
li	$v0, 1
syscall
.end_macro

.macro RI(%n)
li	$v0, 5
syscall
move	%n, $v0
.end_macro

.macro StackIn(%n)
sw	%n, 0($sp)
addi	$sp, $sp, -4
.end_macro

.macro StackOut(%n)
addi	$sp, $sp, 4
lw	%n, 0($sp)
.end_macro

.text:
RI($s0)

move	$a0, $s0
li	$v0, 1
jal factorial

PI($v0)
li	$v0, 10
syscall

factorial:
if_1:
bne 	$a0, 0, if_2
li	$v0, 1
jr	$ra

if_2:
bne 	$a0, 1, else
li	$v0, 1
jr 	$ra

else:
StackIn($a0)
StackIn($ra)

subi	$a0, $a0, 1
jal 	factorial

StackOut($ra)
StackOut($a0)
mul	$v0, $v0, $a0

jr	$ra
