lui	$s0, 0x1234
ori	$s0, 0xabcd
bne	$s0, $s1, label
ori	$s1, 0xffff
lui	$t0, 0x1234
label:
lui	$t1, 0x1234
