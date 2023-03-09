### INCOMPLETE ###	
	.data
even:	.asciiz	" is even.\n"
odd:	.asciiz	" is odd.\n"
num:	.word	4
	.text
main:
	# generate a random number in range [0, 20]
	
	li $v0, 42	# rng service
	li $a1, 21	# upper-bound
	syscall
	sw $a0, num	# save the random number to num
	
	# call functions
	
	jal is_even	# $a0 already contains the random number
	move $a0, $s0	# move the result of is_even function to the argument
	jal display	# display if the argument is even or odd
	
	li $v0, 10
	syscall
	
# given a number, check if it is even or not. 1 for true and 0 for false
is_even:
	addi $sp, $sp, -4	# reserve 4 bytes on the stack
	sw $s0, 0($sp)	# save the result of this function to the stack
	sw $ra, 4($sp)	# save the return address of this function on the stack
	
	la $t0, ($a0)	# load the argument into $t0
	srl $t0, $t0, 1	# shift right logically by 1 bit
	sll $t0, $t0, 1	# shift back the other way by 1 bit
	seq $a0, $t0, $a0	# check if the original and shifted are the same
	
	jal display	# display the result
	
	lw $s0, 0($sp)	# load the result back
	lw $ra, 4($sp)	# load this functions return address back
	jr $ra	# exit function
	
# display a message if the given number is even or odd
display:
	
	beq $a0, 1, evn
	li $v0, 1
	lw $a0, num
	syscall
	
	li $v0, 4
	la $a0, odd
	syscall
	
	jr $ra
	evn:
		li $v0, 1	# print integer service
		lw $a0, num	# load the number
		syscall
		
		li $v0, 4	# print string service
		la $a0, even	# load the message
		syscall

		jr $ra