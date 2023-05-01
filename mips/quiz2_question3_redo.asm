	.data
arr:	.space	80	# reserve enough space to store 20 integer numbers
len:	.word	20	# the size of the array
upp:	.word	21	# the upper bound for the rng (exclusive)
msg1:	.asciiz	" is the maximum.\n"
msg2:	.asciiz	" is the minumum.\n"
	.text
main:
	# generate random values in range [0, 100] and store them in the 'arr' variable
	
	la $t6, arr	# init the base address of the array into $t0
	lw $t7, len	# init the size of the array into $t1
	loop:
		beq $t7, $zero, exit	# exit if we finished
		li $a0, -10		# init the lower bound
		lw $a1, upp		# init the upper bound
		jal gen_num		# call the gen num function
		sw $s0, ($t6)		# save the generated number into the array
		addi $t6, $t6, 4	# update the off-set of the base address
		subi $t7, $t7, 1	# update the size of how many more times we need to add a number to the array
		j loop
	exit:
		la $a0, arr		# load the base address
		lw $a1, len		# load the length of the array
		jal display		# call the display function
	
	# find the maximum and minimum values in the array and print the results
	
	la $a0, arr	# load the base address
	lw $a1, len	# load the length of the array
	jal max_and_min	# call the function
	
	li $v0, 1
	la $a0 ($s0)
	syscall
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 1
	la $a0, ($s1)
	syscall
	li $v0, 4
	la $a0, msg2
	syscall
	
	# exit the program
	
	li $v0, 10
	syscall
############################################################################################
# generates a random number [low, upp] where low is passed as an argument in $a0 and upp
# is passed as the argument in $a1. The number generated is then saved in $s0 as the return
# result of this function
gen_num:
	# reserve space on the stack for our arguments
	
	addi $sp, $sp, -8
	sw $a0, 0($sp)	# preserve the lower bound
	sw $a1, 4($sp)	# preserve the upper bound
	
	# generate the random number and save/set it to $s0 which is the return result of the function
	li $v0, 42		# rng service code
	lw $a1, 4($sp)		# load the upper bound
	syscall
	lw $t0,	0($sp)		# load the lower bound
	add $s0, $a0, $t0	# add the lower bound to the number generated and set it to $s0

	# recover the space on the stack
	
	addi $sp, $sp, 8
	
	# exit the function
	
	jr $ra
############################################################################################
# determines what the maximum and minimum value of the given array is. The array base address is
# assumed ot be at $a0 while the length of the address is at $a1. The results of the function maximum
# and minimum are returned from this function in registers $s0 and $s1, respectively.
max_and_min:
	# preserve the return address
	
	addi $sp, $sp, -4	# reserve 4 bytes on the stack
	sw $ra, 0($sp)		# save the return address to the stack
	
	# function implementation
	
	lw $t0, upp	# init the minimum value
	li $t1, -1	# load the maximum value
	mloop:
		beq $a1, $zero, mexit	# exit the loop if we're done
		lw $t2, ($a0)		# load the value from the array into $t2
		slt $t3, $t2, $t0	# set $t3 to ($t2 < $t0)
		beq $t3, 1, up_min	# branch if $t2 is the new minimum
		sgt $t3, $t2, $t1	# set $t3 to ($t2 > $t1)
		beq $t3, 1, up_max	# branch if $t2 is the new maximum
		j up_iter		# update the iterator
	up_min:
		la $t0, ($t2)	# set the new minimum
		j up_iter	# upate the iterator
	up_max:
		la $t1, ($t2)	# set the new maximum
		j up_iter	# update the iterator
	up_iter:
		addi $a0, $a0, 4	# update the base address
		subi $a1, $a1, 1	# update the length of the array
		j mloop			# continue the loop
	mexit:
		move $s0, $t1	# move the maximum to $s0
		move $s1, $t0	# move the minimum to $s1
	
	# restore the return address
	
	lw $ra, 0($sp)		# restore the base address
	addi $sp, $s0, 4	# de-allocate the space we reserved on the stack
	
	# exit the function
	
	jr $ra
############################################################################################
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
