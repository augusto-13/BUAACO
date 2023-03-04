li	$s0, 4558445
ori	$s1, 1
addu	$s2, $s0, $s1
subu	$s3, $s0, $s1
sw	$s3, 4($0)
sw	$s2, 8($0)
lw	$s4, 4($0)
lw	$s5, 8($0)