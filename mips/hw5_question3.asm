	.data
before:	.asciiz	" (before odd-filtering)\n"
after:	.asciiz	" (after odd-filtering)\n"
	.text
main:
	li $s0, 0xA1B3E5F7	# init the number we're going to be working with in hex format
	
	sll $t0, $s0, 1	# shift this number to the left by 1 bit
	li $v0, 34	# print hexadecimal service
	la $a0, ($t0)	# load our shifted number into the argument
	syscall
	
	li $v0, 11	# print character service
	la $a0, 10	# ASCII code new line
	syscall
	
	srl $t1, $t0, 1	# shift the new number to the right by 1 bit (logical)
	li $v0, 34	# print hexadecimal service
	la $a0, ($t1)	# load the new shifted number into the argument
	syscall
	
	li $v0, 11	# print character service
	la $a0, 10	# ASCII code new line
	syscall
	
	sra $t2, $t1, 1	# shift this new number to the right by 1 bit (arithmetic)
	li $v0, 34	# orubt hexadecimal service
	la $a0, ($t2)	# load the new shifted number into the argument
	syscall
	
	li $v0, 11	# print character service
	la $a0, 10	# ASCII code new line
	syscall
	
	# performing the rotation of this number of 8 bits requires a combination of left-logical shift
	# by 6 bits, then inserting the original MSB into the LSB of this new number (B refers to byte here, not bit)
	
	andi $t3, $t2, 0xFF000000	# ANDi(mmediate) (filter) out the MSB from the number we want to rotate and save it to $t3
	srl $t3, $t3, 24		# shift this number over to the right 24 bits, effectively turning the MSB to an LSB
	sll $t4, $t2, 8			# shift the number to the left 8 bits
	or $t5, $t3, $t4		# OR (merge) our filter + the 8-bit shift to get our rotated number
	
	li $v0, 34	# print hexadecimal service
	la $a0, ($t5)	# load our rotated number into the argument
	syscall
	
	li $v0, 11	# print character service
	la $a0, 10	# ASCII code new line
	syscall
	
	# finally we want to filter out all the odd-placed numbers and display this new number
	li $v0, 35	# print binary service
	la $a0, ($t5)	# load the before into the argument
	syscall
	li $v0, 4	# print string service
	la $a0, before	# load the before message into the argument
	syscall

	andi $t6, $t5, 01010101010101010101010101010101	# only keep the even-placed bits by filtering out the rest
	srl $t6, $t6, 1	# shift the numbers to the left one to put them back to their original position
	
	li $v0, 35	# print binary service
	la $a0, ($t6)	# load the after into the argument
	syscall
	li $v0, 4	# print string service
	la $a0, after	# load the after message into the argument
	syscall
	
	
	
	
