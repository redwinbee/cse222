	.data
len:		.word	30	# 20 integer numbers
arr:		.space	120	# (30 * 4 bytes) = 120 bytes
low:		.word	0	# lower bound
upp:		.word	0	# upper bound
msg_ask_bounds:	.asciiz "-= please enter the lower and upper bounds to generate array [lower, upper] =-\n"
msg_low_bound:	.asciiz	"lower bound: "
msg_upp_bound:	.asciiz	"upper bound: "
msg_creating:	.asciiz "generating array..."
	.text 
main:
	# get the lower and upper bound for array generation
	
	li $v0, 4
	la $a0, msg_ask_bounds
	syscall
	la $a0, msg_low_bound
	syscall
	li $v0 5
	syscall
	sw $v0, low
	li $v0, 4
	la $a0, msg_upp_bound
	syscall
	li $v0, 5
	syscall
	sw $v0, upp
	
	# populate the array with random values in range [low, upp]
	
	la $s0, arr
	lw $s1, len
	pop_array_loop:
		beqz $s1, pop_array_loop_end
		jal gen_num
		sw $v0, ($s0)
		addi $s0, $s0, 4
		subi $s1, $s1, 1
		j pop_array_loop
	pop_array_loop_end:
	
	# display the array
	
	la $a0, arr
	lw $a1, len
	jal display_array
	
	# exit the program
exit:
	li $v0, 10
	syscall
###########################################################################################
# generates a random number in range [lower, upper]. this function assumes the following
# conditions have been met prior to being called:
# 'low' has been initialized
# 'upp' has been initialized
#
# returns:
# $v0 = generated number in range [lower, upper]
gen_num:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	lw $t0, low
	lw $t1, upp
	sub $a1, $t1, $t0
	addi $a1, $a1, 1
	li $v0, 42
	syscall
	move $v0, $a0
	add $a0, $a0, $t0
	
	# housekeeping
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
############################################################################################
# this function will be called with the assumption that the base address is stored in $a0,
# and that the size of the array is stored in $a1.
display_array:
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