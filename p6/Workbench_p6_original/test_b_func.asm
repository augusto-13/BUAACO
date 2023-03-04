# $signed() !!!!! 不要再被坑了！！！

# $t0 = 0x7fff_fffe ( > 0 ) <s>
lui	$t0, 0x7fff
ori	$t0, 0xfffe

# $t1 = 0x7fff_ffff ( > 0 ) <b>
lui	$t1, 0x7fff
ori	$t1, 0xffff

# $t2 = 0xffff_0001 ( < 0) <s>
lui	$t2, 0xffff
ori	$t2, 0x0001

# $t3 = 0xffff_0002 ( < 0) <b>
lui	$t3, 0xffff
ori	$t3, 0x0002

jal	if_1
nop

else_1:
ori	$s0, 0xffff
jal	if_2
nop

else_2:
ori	$s1, 0xffff
jal	if_3
nop

else_3:
ori	$s2, 0xffff
jal	if_4
nop

else_4:
ori	$s3, 0xffff
jal	if_5
nop

else_5:
ori	$s4, 0xffff
jal	if_6
nop

else_6:
ori	$s5, 0xffff
jal	none
nop

if_1:
bne	$t0, $t0, else_1
nop

if_2:
bgtz	$t1, else_2
nop

if_3:
bgtz	$t2, else_3
nop

if_4:
blez	$0, else_4
nop

if_5:
bgez	$0, else_5
nop

if_6:
beq	$t1, $t1, else_6
nop

none:
nop


