	.text
main:
	lui $s0, 0xABCD		# Load upper 16 bits of 0xABCD2468 into $s0
	ori $s0, $s0, 0x2468	# OR lower 16 bits of 0xABCD2468 with $s0 and store result in $s0
	
	##################################################################
	
	li $s1, 0xEFAB		# load the first 2 bytes that we're going to shift
	sll $s1, $s1, 16	# shift the number to the upper part
	addi $s1, $s1, 0x1357	# add the rest of the number to $s1
	
	##################################################################
	
	lui $s2, 0xFFFF		# filter to extract 2 bytes
	and $s3, $s0, $s2	# extract the upper 2 bytes from $s0
	srl $s2, $s2, 16	# shift to the right 16 bits to extract lower 2 bytes
	and $s4, $s1, $s2	# extract the lower 2 bytes from $s1
	or $s5, $s3, $s4
	
	##################################################################
	
	li $v0, 34
	move $a0, $s5
	syscall