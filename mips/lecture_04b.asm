	.data
sum_msg:	.asciiz	"The summation of 0..100 is "
eqmsg:		.asciiz	"equal..."
greater:	.asciiz	"greater..."
pow_msg:	.asciiz	"the power of this number is "
	.text
main:
	# calculate the sum of the numbers from 0..100
	
	addi $s0, $zero, 0	# init index of loop
	addi $s1, $zero, 0	# init the current sum of the numbers
	addi $s2, $zero, 100	# init the upper-bound (exclusive)
	
add_loop:
	beq $s0, $s2, display_sum	# check if we've gone over the upper-bound, if not then go to keep_adding
	add $s1, $s1, $s0		# add the current index and current sum together and save it back to the same location $s1
	addi $s0, $s0, 1		# update the index by 1 and save it back to the same spot $s0
	j add_loop
display_sum:
	li $v0, 4	# print string service
	la $a0, sum_msg	# load the msg to display
	syscall
	
	li $v0, 1	# print integer service
	la $a0, 0($s1)	# load the contents of the sum into the argument $a0
	syscall
		# generate two random numbers in range [0,100] and compare the two numbers. display message based on the results
	
#	li $v0, 42	# random number generator service
#	li $a1, 101	# upper-bound for rng
#	syscall
#	move $t0, $a0	# move the first random number to $s0
#	syscall
#	move $t1, $a0	# move the second random number to $s1
#	
#	beq $t0, $t1, eq	# $s0 == $s1
#	slt $t2, $t0, $t1	# $t0 < $t1
#	beq $t2, $zero, gr
#	j dis
#
#eq:
#	li $v0, 4
#	la $a0, eqmsg
#	syscall
#	j dis
#gr:
#	li $v0, 4
#	la $a0, ($t2)
#
#dis:
	