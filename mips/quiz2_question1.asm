	.data
	.text
main:
	li $s0, 0xABCD1234	# load first hex value into $s0
	
	lui $s1, 0xEFAB		# load this hex number into the upper two bytes of $s1
	addi $s1, $s1, 0x1357	# add the rest using addi to complete the number
	
	#  extract upper two bytes from $s0 and lower two bytes from $s1 and merge them together in $s2
	
	lui $t0, 0xFFFF	# filter
	and $t1, $s0, $t0 # upper 2  bytes
	srl $t1, $t1, 16
	andi $t2, $s1, 0xFFFF	# lower 2 bytes
	sll $s2, $t2, 16	# shift 2 bytes to the left
	add $s2, $s2, $t1
	
	# display the number
	
	li $v0, 34
	move $a0, $s2
	syscall