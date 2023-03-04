ori	$t0, 1
ori 	$t1, 1
jal	label_1
ori	$ra, $0, 0x3100
label_1:
addu	$t2, $t1, $t2
jr	$ra
