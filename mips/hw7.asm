	.data
arr:	.space	80
len:	.word	20
msg1:	.asciiz	"There are "
msg2:	.asciiz " even number(s) and "
msg3:	.asciiz	" odd number(s).\n"
	.text
main:
	# populate an array with 20 randomly generated numbers in range [10, 100]
	
	la $t9, arr	# load the base address into $t0
	lw $t8, len	# load the size of the array into $t1
	li $t7, 0	# init the index
	li $a0, 10	# init lower bound for rng
	li $a1, 100	# init upper bound for rng
	loop:
		jal gen_num	# call rng function
		sw $s0, ($t9)	# store the generated number into the array
		addi $t7, $t7, 1	# update the index
		addi $t9, $t9, 4	# update the base address
		blt $t7, $t8, loop	# keep looping if we're not done
	
	# display the array we just generated
	
	la $a0, arr	# init the base address
	lw $a1, len	# init the length of the array
	jal display	# call display function
	
	# count the number of evens and odds in the array and print the messages
	
	la $a0, arr	# init the base address
	lw $a1, len	# init the length of the array
	jal count_even_odds	# call count function
	
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, msg2
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	li $v0, 4
	la $a0, msg3
	syscall
	
	
	# exit the program
	
exit:
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
# given an array and a length, count the number of times an even number appears and set it
# to the return value of $s0--this also means that since we know the length of the array and
# how many even numbers it contains, every other number in the array is odd by default so count
# and return that value in $s1
count_even_odds:
	# reserve space on the stack for our arguments
	
	addi $sp, $sp, -12
	sw $a0, 0($sp)	# preserve the base address of the array
	sw $a1, 4($sp)	# preserve the length of the array
	sw $ra, 8($sp)	# preserve the return address
	
	# count the number of times we encounter an even number and save it; then we can
	# subtract the length of the array by the number of evens to extract the number of
	# odds and save that too
	
	li $t0, 0	# init the index
	li $t1, 0	# init the counter of even numbers
	la $t2, 0($sp)	# init the base address	
	cloop:
		lw $a0, ($t2)		# load the value from the array into $a0
		jal is_even		# check if the number is even, return value in $s0
		beq $s2, 1, even	# branch to 'even' if the number was even
		addi $t2, $t2, 4	# update the base address to advance to the next number
		addi $t0, $t0, 1 	# update the index
		ble $t0, $a1, cloop	# continue the loop if necessary
		j cexit			# exit the loop
		even:
			addi $t1, $t1, 1	# update the number of even numbers
			addi $t2, $t2, 4	# update the base address to advance to the next number
			addi $t0, $t0, 1	# update the index
			ble $t0, $a1, cloop	# continue the loop if necessary
	cexit:
		move $s0, $t1		# move the even counter to the return register $s0
		sub $s1, $a1, $s0	# calculate how many odd numbers there are and set it to $s1
	
	# de-allocate the space on the stack and retrieve the return address
	
	lw $ra, 8($sp)		# load the original return address back into $ra
	addi $sp, $sp, 12	# recover the space we allocated earlier
	
	# exit the function
	
	jr $ra		
############################################################################################
# HELPER FUNCTION to determine if a number is even or odd; said number is assumed to be in $a0
# and the result is sent back in $s2. If the number is even return 1, otherwise 0.
is_even:
	srl $t9, $a0, 1	# shift the number to the right (logically) by 1
	sll $t9, $t9, 1	# shift the number to the left (logically) by 1
	beq $a0, $t9, yes		# branch to yes since the two numbers are still the same
	li $s2, 0	# set the return result to false (0)
	jr $ra		# exit the function
	yes:
		li $s2, 1	# set the return result to true (1)
		jr $ra		# exit the function
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