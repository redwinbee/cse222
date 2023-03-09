	.data
min:	.asciiz	" is the minimum number.\n"
max:	.asciiz	" is the maximum number.\n"
avg:	.asciiz " is the average.\n"
	.text 
main:
	li $s0, 1	# init the index (counter for loop)
	li $s1, -1	# init the maximum number
	li $s2, 101	# init the minimum number
	li $s3, 0	# init the average
loop:
	li $v0, 42		# rng service code
	li $a1, 91		# load the upper-bound into the argument for the rng
	syscall
	addi $a0, $a0, 10	# add the lower-bound to the random number
	move $s4, $a0		# move the random number to $s4 for safe-keeping
		
	# check if we need to update the maximum number
	bgt $s4, $s1, new_max
	j up_min	# nothing to update
new_max:
	la $s1, ($s4)	# update the maximum number
	
up_min:
	# check if we need to update the minimum number
	blt $s4, $s2, new_min
	j up_avg	# nothing to update
new_min:
	la $s2, ($s4)	# update the minimum number

up_avg:
	# add this number to the current avg (yet to be divided)
	add $s3, $s3, $s4
	
	addi $s0, $s0, 1	# update the index by 1
	blt $s0, 20, loop	# loop until we do this $s0-number of times (index)
	j exit			# we're done, go to the exit
exit:
	div $s3, $s3, $s0	# divide to get the average (integer)
	
	li $v0, 1	# print integer service
	la $a0, ($s1)	# maximum number
	syscall
	li $v0, 4
	la $a0, max
	syscall
	
	li $v0, 1	# print integer service
	la $a0, ($s2)	# minimum number
	syscall
	li $v0, 4
	la $a0, min
	syscall
	
	li $v0, 1	# print integer service
	la $a0, ($s3)	# average (integer division)
	syscall
	li $v0, 4
	la $a0, avg
	syscall
	
	li $v0, 10	# terminate program
	syscall