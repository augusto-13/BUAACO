.data:
symbol: 	.space		32
array:		.space		32
str_space: 	.asciiz		" "
str_enter:	.asciiz		"\n"

.macro getindex(%ans, %i)
sll	%ans, %i, 2
.end_macro


.macro PI(%n)
li	$v0, 1
move	$a0, %n
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

.macro PS
li	$v0, 4
la	$a0, str_space
syscall
.end_macro

.macro PE
li	$v0, 4
la	$a0, str_enter
syscall
.end_macro

.macro END
li	$v0, 10
syscall
.end_macro
 
.text:
RI($s0)				# $s0 -> n	

li	$a0, 0
jal 	FullArray

END

FullArray:
if_1:
blt	$a0, $s0, else_1
li	$t0, 0

for_1:
beq	$t0, $s0, for_1_end

getindex($t1, $t0)
lw	$t1, array($t1)
PI($t1)
PS
addi	$t0, $t0, 1
j	for_1

for_1_end:
li	$t0, 0
PE
jr	$ra

else_1:
li	$t0, 0

for_2:
beq		$t0, $s0, for_2_end			######

if_2:
getindex($t1, $t0)
lw	$t4, symbol($t1)	# $t4 -> symbol [i]
bne	$t4, $0, else_2	# $t1 -> index_symbol [i]
getindex($t3, $a0)		# $t3 -> index_array[index]
addi	$t2, $t0, 1		# $t2 -> (i + 1)
sw	$t2, array($t3)
li	$t2, 1			# $t2 -> 1
sw	$t2, symbol($t1)		# symbol[i] = 1

StackIn($t1)
StackIn($ra)
StackIn($t0)
StackIn($a0)
addi	$a0, $a0, 1
jal	FullArray
StackOut($a0)
StackOut($t0)
StackOut($ra)
StackOut($t1)
sw	$0, symbol($t1)

else_2:
addi	$t0, $t0, 1
j	for_2

for_2_end:
li	$t0, 0
jr	$ra
