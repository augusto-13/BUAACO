.data:
a:	.space		400
f: 	.space 		400
dirtp:	.space		16
dirtq:	.space		16

.macro get_2_index(%ans, %i, %j)
mul 	%ans, %i, 10
add	%ans, %ans, %j
sll	%ans, %ans, 2
.end_macro

.macro get_1_index(%ans, %n)
sll	%ans, %n, 2
.end_macro

.macro Call_It_A_Day
li	$v0, 10
syscall
.end_macro

.macro RI(%n)
li	$v0, 5
syscall
move	%n, $v0
.end_macro

.macro PI(%n)		#顺序千万不要反！！！！
move	$a0, %n
li	$v0, 1
syscall
.end_macro

.macro	StackIn(%n)
sw	%n, 0($sp)
addi	$sp, $sp, -4
.end_macro

.macro	StackOut(%n)
addi	$sp, $sp, 4
lw	%n, 0($sp)
.end_macro

.text:
li	$t8, 1
li	$t0, 0
li	$t1, 1
li	$t2, -1
li	$t3, 0
sw	$t0, dirtp($t3)
sw	$t1, dirtq($t3)
li	$t3, 4
sw	$t0, dirtp($t3)
sw	$t2, dirtq($t3)
li	$t3, 8
sw	$t1, dirtp($t3)
sw	$t0, dirtq($t3)
li	$t3, 12
sw	$t2, dirtp($t3)
sw	$t0, dirtq($t3)

RI($s0)
RI($s1)
li	$t0, 0
li	$t1, 0
for_1:
beq	$t0, $s0, for_1_out
for_2:
beq	$t1, $s1, for_2_out
RI($t2)					# $t2 -> scanf(a[i][j])
get_2_index($t3, $t0, $t1)		# $t3 -> index_[i][j]
sw	$t2, a($t3)			# scanf(a[i][j]) completed
addi	$t1, $t1, 1			# j++
j	for_2
for_2_out:
li	$t1, 0
addi	$t0, $t0, 1			# i++
j	for_1
for_1_out:
li	$t0, 0

RI($s2)
RI($s3)
RI($s4)
RI($s5)
subi	$s2, $s2, 1
subi	$s3, $s3, 1
subi	$s4, $s4, 1
subi	$s5, $s5, 1
move	$a0, $s2
move	$a1, $s3

get_2_index($s6, $s2, $s3)
sw	$t8, f($s6)

li	$v0, 0
jal	DFS

PI($v0)
Call_It_A_Day


DFS:
if_1:
seq  	$s6, $a0, $s4
beq	$s6, $0, else_1
seq	$s6, $a1, $s5
beq	$s6, $0, else_1
addi	$v0, $v0, 1
jr	$ra

else_1:
li	$t0, 0

for_3:
beq 	$t0, 4, for_3_out
get_1_index($t1, $t0)
get_1_index($t2, $t0)
lw	$t1, dirtp($t1)			# $t1 -> dirtp(index_i)
lw	$t2, dirtq($t2)			# $t2 -> dirtq(index_i)
add	$t1, $t1, $a0			# $t1 -> p_
add	$t2, $t2, $a1			# $t2 -> q_
if_2:
sge 	$s6, $t1, 0
beq	$s6, $0, if_2_out
slt	$s6, $t1, $s0
beq	$s6, $0, if_2_out
sge 	$s6, $t2, 0		# q_ >= 0
beq	$s6, $0, if_2_out
slt	$s6, $t2, $s1		# q_ < m
beq	$s6, $0, if_2_out
# 条件出错了，如果p_ >= 0 && p_ < n && q_ >= 0 && q_ < m 不满足， 后面的条件判断也就没有意义，系统自然会报错
get_2_index($s6, $t1, $t2)
lw	$s6, f($s6)
seq	$s6, $s6, 0
beq	$s6, $0, if_2_out
get_2_index($s6, $t1, $t2)
lw	$s6, a($s6)
seq	$s6, $s6, 0
beq	$s6, $0, if_2_out

get_2_index($s6, $t1, $t2)
sw	$t8, f($s6)
StackIn($t1)
StackIn($t2)
StackIn($a0)
StackIn($a1)
StackIn($t0)
StackIn($ra)
StackIn($s6)

move	$a0, $t1
move	$a1, $t2
jal	DFS

StackOut($s6)
StackOut($ra)
StackOut($t0)
StackOut($a1)
StackOut($a0)
StackOut($t2)
StackOut($t1)

sw	$0, f($s6)

if_2_out:
addi	$t0, $t0, 1
j	for_3

for_3_out:
li	$t0, 0
jr	$ra

#java -jar mars4_5.jar nc me P2_L1_puzzle.asm < data.in 1> a.out 2>err.txt
