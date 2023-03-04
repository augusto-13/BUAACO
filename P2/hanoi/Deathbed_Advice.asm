.data:
a:	.space		256
str_enter:	.asciiz		"\n"
str_space:	.asciiz		" "

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

.macro PE
la	$a0, str_enter
li	$v0, 4
syscall
.end_macro

.macro PS
la	$a0, str_space
li	$v0, 4
syscall
.end_macro

.macro StackIn(%n)
sw	%n, 0($sp)
addi	$sp, $sp, -4
.end_macro

.macro StackOut(%n)
addi	$sp, $sp, 4
lw	%n, 0($sp)
.end_macro

