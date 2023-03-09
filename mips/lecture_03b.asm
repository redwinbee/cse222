	.text
main:
	# swap 0xABCD1234 -> 0x1234ABCD
	
	lui $t0, 0xABCD		# set upper bytes to 0xABCD
	addi $t0, $t0, 0x1234	# add 0x1234 to $t0 (lower bytes)
	sll $s0, $t0, 16	# logically shift left the bytes in $t0 by 16 and store the result in $s0
	srl $s1, $t0, 16	# logically shift right the bytes in $t0 by 16 and store the result in $s1
	or $s2, $s0, $s1	# perform ($s0 OR $s1) and store the result in $s2. This has the effect of merging the two registers into 1 (bit-wise)
