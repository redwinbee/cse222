	.data
rand:		.asciiz	" is the random number in range [2, 1000]\n"
even1:		.asciiz " is an even number (method 1)\n"
odd1:		.asciiz	" is an odd number (method 1)\n"
even2:		.asciiz	" is an even number (method 2)\n"
odd2:		.asciiz	" is an odd number (method 2)\n"
even3:		.asciiz	" is an even number (method 3)\n"
odd3:		.asciiz	" is an odd number (method 3)\n"
div3n5y:	.asciiz " is divisible by 3 and 5\n"
div3n5n:	.asciiz	" isn't divislble by 3 and 5\n"
	.text
main:
	# generate a number in range [2, 1000] and print the number to console
	
	li $a1, 1001		# upper-bound of the rng
	li $v0, 42		# rng service code
	syscall
	addi $a0, $a0, 2	# make sure the lower-bound is 2
	move $s0, $a0		# copy our random number over to $s0
	
	li $v0, 1		# print integer service code
	la $a0, ($s0)		# load the random number
	syscall
	
	li $v0, 4		# print string service code
	la $a0, rand		# load the rng number message
	syscall
	
	# (method 1) of determining if the random number is even or odd -- LSB check
	# since the least significant bit represents a value of 1 or 0, this means an odd number will
	# have a 1 in the LSB since odd numbers are of the form (2k + 1)
	
	li $t0, 1		# marker for odd
	and $t1, $s0, $t0	# filter check for 1 in the LSB
	
	beqz $t1, is_even1	# check if there is a bit in the LSB
	li $v0, 1		# print integer service code
	la $a0, ($s0)		# load the random number
	syscall
	
	li $v0, 4		# print string service code
	la $a0, odd1		# load the odd message
	syscall
	
	j method_2
	
is_even1:
	li $v0, 1		# print integer service code
	la $a0, ($s0)		# load the random number
	syscall
	
	li $v0, 4		# print string service code
	la $a0, even1		# load the even message
	syscall

	# (method 2) of determining if the random number is even or odd -- "bit-loss" check
	# by shifting the value of the random number to the right by 1 bit, then back left by 1
	# bit (logically), we can then check if the value of this number has changed. If it is still
	# the same number then we know it was even; otherwise odd.
method_2:
	la $t0, ($s0)		# load the random number into $t0
	srl $t1, $t0, 1		# logically shift right by 1 bit
	sll $t1, $t1, 1		# logically shift left by 1 bit
	
	blt $t1, $t0, is_odd2	# the shifted number is less than the original, meaning we lost +1 so the number was odd
	li $v0, 1		# print integer service code
	la $a0, ($s0)		# load the random number
	syscall
	
	li $v0, 4		# print string service code
	la $a0, even2		# load the even message
	syscall
	
	j method_3
is_odd2:
	li $v0, 1		# print integer service code
	la $a0, ($s0)		# load the random number
	syscall
	
	li $v0, 4		# print string service code
	la $a0, odd2		# load the odd message
	syscall
	
	j method_3
	
	# (method 3) of determining if the random number is even or odd -- divisor check
	# perhaps the simplest but certainly not most efficient way of checking if a number is even or odd is
	# by checking if it is evenly divisble by 2. no explanation needed.
method_3:
	li $t0, 2		# load the divisor into $t0
	div $s0, $t0		# perform the divison
	mfhi $t1		# get the remainder, if any
	
	beqz $t1, is_even3
	li $v0, 1		# print integer service code
	la $a0, ($s0)		# load the random number
	syscall
	
	li $v0, 4		# print string service code
	la $a0, odd3		# load the odd message
	syscall
	
	j qtwothree		# jump to question 2(3)
is_even3:
	li $v0, 1		# print integer service code
	la $a0, ($s0)		# load the random number
	syscall
	
	li $v0, 4		# print string service code
	la $a0, even3		# load the even message
	syscall
	
	
	# check if this random number is divisible by 3 and 5
qtwothree:
	li $t0, 15      	# load the LCM of 3 and 5 as the divisor
	div $s0, $t0    	# divide the random number by the LCM
	mfhi $t1        	# move the remainder, if any, to $t1
	
	beq $t1, $zero, isdiv3n5# branch if the random number was evenly divided by the LCM
	li $v0, 1		# print integer service
	la $a0, ($s0)		# load the random number to print
	syscall
	li $v0, 4		# print string service
	la $a0, div3n5n		# load the string to print
	syscall
	
	j qtwofour		# jump to question 2(4)

isdiv3n5:
	li $v0, 1		# print integer service
	la $a0, ($s0)		# load the random number to print
	syscall
	li $v0, 4		# print string service
	la $a0, div3n5y		# load the string to print
	syscall

	# check if this random number is divisble by 7 and 9 but not both
	# this is very similar to the previous question, however this time we will use XOR
	# which means we can't rely on the LCM since we need both divisors
qtwofour:
	li $t0, 7	# load the first divisor
	li $t1, 9	# load the second divisor
	div $s0, $t0	# divide by the first divisor
	mfhi $t2	# move the remainder into $t2
	div $s0, $t1	# divide by the second divisor
	mfhi $t3	# move the remainder into $t3