lui	$t0, 0xabcd
ori 	$t0, $t0, 0xf2f8
j		label				# jump to label
lb	$t6, 5($0)
lh	$t7, 6($0)
sw	$t0, 0($0)
lw	$t1, 0($0)
label:
sh	$t0, 6($0)
lh	$t2, 6($0)
lhu	$t3, 6($0)
sb	$t0, 9($0)
lb	$t4, 9($0)
lbu	$t5, 9($0)
