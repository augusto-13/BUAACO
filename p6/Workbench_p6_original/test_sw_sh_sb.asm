jal	label_1
li	$t0, 0x89abcdef
sw	$t0, 0($0)	# 0(0)
sb	$t0, 5($0)	# 1(4)
sh	$t0, 10($0)	# 2(8)
sb	$t0, 15($0)	# 3(12)

label_1:
li	$t0, 0x89abcdef
sw	$t0, 16($0)	# 0(16)
sb	$t0, 21($0)	# 1(20)
sh	$t0, 26($0)	# 2(24)
sb	$t0, 31($0)	# 3(28)
bne	$t0, $0, label_2
nop

li	$t1, 0x55555555
sw	$t1, 24($0)	# 0(24)
sh	$t0, 26($0)	# 2(24)

label_2:
lw	$t0, 0($0)	# $8 <= 0
addu	$t0, $t0, $0	#stall (load, cal_R)
lhu	$t2, 10($0)	# 0x0000cdef
lh	$t3, 10($0)	# 0xffffcdef
lb	$t4, 31($0)	# 0xffffffef
lbu	$t5, 31($0)	# 0x000000ef
