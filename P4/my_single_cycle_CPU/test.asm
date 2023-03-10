# swl 以 rs + Imm 为起点，将最左端字节填入，接下来向右依次填充，直至将本字填满
li	$t0, 0x89abcdef
swl	$t0, 0($0)	# 0(0)
swl	$t0, 5($0)	# 1(4)
swl	$t0, 10($0)	# 2(8)
swl 	$t0, 15($0)	# 3(12)

# swr 以 rs + Imm 为起点，将最右端字节填入，接下来向左依次填充，直至将本字填满
li	$t0, 0x89abcdef
swr	$t0, 16($0)	# 0(16)
swr	$t0, 21($0)	# 1(20)
swr	$t0, 26($0)	# 2(24)
swr	$t0, 31($0)	# 3(28)

# 测试 swl, swr 对原数据是否有影响
li	$t1, 0x55555555
sw	$t1, 24($0)	# 0(24)
swr	$t0, 26($0)	# 2(24)
# 无影响
