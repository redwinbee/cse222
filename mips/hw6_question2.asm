	.data
arr:	.space	80	# reserve 80 bytes of space for the array
siz:	.word	20	# the size of the array
itr:	.word	20	# the number of times to perform the shuffling on the array
tmp:	.word	20	# temporary variable to store value during swapping
i1:	.word	20	# first random index
i2:	.word	20	# second random index
	.text
main:
	li $t0, 1	# init the counter for the array
	la $t1, arr	# init the base address of the array
	lw $t2, siz	# init the size of the array

	loop:
		sw $t0, ($t1)		# store the current count in the array
		addi $t0, $t0, 1	# update the counter by 1
		addi $t1, $t1, 4	# update the base address to the next available 4 bytes
		sle $t3, $t0, $t2	# $t3 = ($t0 <= $t2)
		beq $t3, 1, loop	# loop again since we're not done
	
	la $a0, arr	# load the base address of the array into arg 0
	move $a1, $t2	# move the size of the array into arg 1
	jal display	# call the display function
	
	la $a0, arr	# load the base address again into $a0
	lw $a1, siz	# load the size of the array again into $a1
	lw $a3, itr	# load the number of iterations to perform the shuffling
	jal shuffle	# call the shuffle function
	
	la $a0, arr
	lw $a1, siz
	jal display
	
	j exit
	
###########################################################################################

# this function will be called with the assumption that the base address is stored in $a0,
# and that the size of the array is stored in $a1.
display:
	addi $sp, $sp, -8	# reserve 8 bytes on the stack
	sw $a0, 0($sp)		# store the base address on the stack
	sw $a1, 4($sp)		# store the size of the array on the stack
	
	li $v0, 11	# print character service
	li $a0, 91	# ASCII code '['
	syscall
	li $a0, 32	# ASCII code SPACE
	syscall
	
	lw $t0, 0($sp)	# load the base address into $t0
	lw $t1, 4($sp)	# load the size of the array into $t1
	li $t2, 1	# init the counter
	dloop:
		li $v0, 1	# print integer service
		lw $a0, ($t0)	# the number to print
		syscall
		li $v0, 11	# print character service
		li $a0, 32	# ASCII code SPACE
		syscall
		
		addi $t0, $t0, 4	# advance to the next element in the array
		addi $t2, $t2, 1	# update the counter by 1
		ble $t2, $t1, dloop	# loop if there are still more elements to process
		
	li $v0, 11	# print character service
	li $a0, 93	# ASCII code ']'
	syscall
	
	addi $sp, $sp, 8	# de-allocate the 8 bytes we reserved earlier
	li $v0, 11	# print character service
	li $a0, 10	# ASCII code new-line
	syscall
	jr $ra	# end of function

###########################################################################################

# shuffle the array given to this function, just like the display function the array is assumed to be
# in the $a0 register and its size in the $a1 register. shuffling can be achieved by randomly selecting
# two indices in the array and swapping their values; the shuffling can be even more "random" by choosing
# to perform this action even more times. IE: 10 iterations is less "random" than 100 and so on...
shuffle:
	addi $sp, $sp, -12	# allocate 12 bytes on the stack
	sw $a0, 0($sp)		# store the base address on the stack
	sw $a1, 4($sp)		# store the size of the array on the stack
	sw $a3, 8($sp)		# store the number of iterations to perform
	
	lw $t0, 0($sp)	# load the base address
	lw $t1, 4($sp)	# load the size of the array
	li $t9, 0	# init the counter
	sloop:
		# generate two random indices for shuffling
		
		li $v0, 42	# rng service
		la $a1, ($t1)	# the upper-bound of the array to generate indices
		syscall
		sw $a0, i1	# store the first index
		syscall
		sw $a0, i2	# store the second index
		
		# swap the two values at the indices
		
		lw $t8, i1	# load the first index
		mul $t7, $t8, 4	# multiply the index by the space each integer takes (4 bytes) to get the correct off-set
		add $t7, $t0, $t7	# add this off-set to the base address
		lw $t4, ($t7)	# value at the first random index
		sw $t4, tmp	# store this value temporarily
		
		lw $t8, i2	# load the second index
		mul $t7, $t8, 4	# same as above, calculate the correct off-set
		add $t7 ,$t0, $t7	# add the off-set to the base address
		lw $t5, ($t7)	# vlaue at the second random index
		
		move $t4, $t5	# swap the value at $t4 with $t5
		lw $t5, tmp	# put the temp value from $t4 into $t5
		
		# save the two values $t4, $t5 back to the array
		
		lw $t8, i1	# load the first index
		mul $t7, $t8, 4	# multiply the index by the space each integer takes (4 bytes) to get the correct off-set
		add $t7, $t0, $t7	# add this off-set to the base address
		sw $t4, ($t7)	# save the swapped value back to the array
		
		lw $t8, i2	# load the second index
		mul $t7, $t8, 4	# same as above, calculate the correct off-set
		add $t7 ,$t0, $t7	# add the off-set to the base address
		sw $t5, ($t7)	# save the swapped value back at the index
		
		# check if we need to repeat this process
		
		addi $t9, $t9, 1	# update the counter
		slt $t6, $t9, $a3	# check if we reached the counter
		beq $t6, 1, sloop	# not done yet, loop again
	
	addi $sp, $sp, 12	# de-allocate the 12 bytes on the stack
	jr $ra
	
exit:
	li $v0, 10
	syscall