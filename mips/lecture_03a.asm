	.text
main:
	# load the value 0xABCD1234 into memory and print it to the console as hexadecimal
	
	lui $t0, 0xABCD		# load this value into the upper two bytes of $t0
	addi $t0,$t0, 0x1234	# add 0x1234 to $t0 and update $t0
	li $v0, 34		# print hexadecimal service
	la $a0, ($t0)		# load our hexadecimal number into the argument for print service
	syscall
	
	li $v0, 11		# print character service
	la $a0, 32		# ASCII code ' '
	syscall
	
	# keep only the first two upper bits of 0xABCD1234 and store this value in $s0 and print
	
	lui $t1, 0xFFFF		# store our "filter" into the upper two bytes of $t1
	and $s0, $t0, $t1	# bit-wise AND which acts like a filter
	
	li $v0, 34		# print hexadecimal service
	la $a0, ($s0)		# load out hexadecimal number into the argument for print service
	syscall