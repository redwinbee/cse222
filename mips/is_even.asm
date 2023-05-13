	.data
msg_ask:	.asciiz	"please enter a number to check: "
msg_even:	.asciiz	" is an even number.\n"
msg_odd:	.asciiz	" is an odd number. \n"
input:		.word	0
	.text
main:
	# ask for a number from the user
	li $v0, 4
	la $a0, msg_ask
	syscall
	li $v0, 5
	syscall
	sw $v0, input
	
	# check with the different is_even functions
	lw $a0, input
	jal is_even_method_1
	move $a0, $v0
	lw $a1, input
	jal print_result
	
	# exit the program
	li $v0, 10
	syscall
###############################################################
# (method 1): check if a number is even by diving it by 2 and
# checking if the remainder is 0.
# assumes the following:
# $a0 = the number to check
#
# returns the following values stored in $v0:
# 1 = the number is even
# 0 = the number is odd
is_even_method_1:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $t0, 2
	div $a0, $t0
	mfhi $t1
	bgtz $t1, odd_method_1
	li $v0, 1
	j exit_method_1
	odd_method_1:
		li $v0, 0
	
	# housekeeping
	exit_method_1:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
###############################################################
# $a0 = result of even_odd check
# $a1 = number that was checked
print_result:
	# housekeeping
	add $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	# implementation
	beq $a0, $zero, print_odd
	lw $a0, 8($sp)
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, msg_even
	syscall
	j print_exit
	print_odd:
		lw $a0, 8($sp)
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, msg_odd
		syscall
	# housekeeping
	print_exit:
		lw $ra, 0($sp)
		addi $sp, $sp, 12
		jr $ra