ori	$s0, 0x3018

jalr	$s0
nop

ori	$t0, 0xffff
j	label
nop

ori	$t1, 0xffff
jr	$ra
nop

label: nop