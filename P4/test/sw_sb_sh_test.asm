.data:
s: 	.space		40

.text:
li	$t1, 0x2345acff
li	$t2, 0x12345678
sw	$t1, 0($0)		# sw only operates on only " 4 * n "
sh	$t1, 4($0)
sh	$t1, 6($0)
# sh	$t1, 9($0)		# sh only operates on only " 4 * n, 2 + 4 * n "
sb	$t2, 8($0)		
sb	$t1, 9($0)		# sb operates on everywhere
sb	$t2, 11($0)