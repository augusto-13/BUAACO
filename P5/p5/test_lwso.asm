lui	$1, 0xffff
ori	$1, 0xffff
ori	$2, 0xffff
sw	$1, 0($0)
sw	$2, 4($0)
lw	$3, 0($0)
addu	$5, $3, $0
lw	$4, 4($0)
addu	$6, $4, $0