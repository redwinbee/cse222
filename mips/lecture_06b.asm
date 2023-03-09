	.data
ask1:	.asciiz	"Please enter the lower number: "
ask2:	.asciiz	"Please enter the upper number: "
low:	.word	4
upp:	.word	4
	.text
main:
	# ask the user to enter two numbers and save them
	
	li $v0, 4
	la $a0, ask1
	syscall
	li $v0	5
	syscall
	sw $v0, low
	
	li $v0, 4
	la $a0, ask2
	syscall
	li $v0, 5
	syscall
	sw $v0, upp
	
	# call the function
	
	lw $a0, low
	lw $a1, upp
	jal func1
	
	# exit program
	
	li $v0, 10
	syscall
	
func1:
	# housekeeping
	
	addi $sp, $sp, -4	# reserve 8 bytes on the stack
	sw $s0, 0($sp)		# save the return result of this fucntion to the stack
	sw $ra, 0($sp)		# save the return address to the stack
	
	# generate a random number in range [low, upp]
	
	li $v0, 42
	syscall	# $a1 already contains the upper-bound
	move $s0, $a0
	
	# call the display function
	
	jal display
	
	# more housekeeping
	
	addi $sp, $sp, 4
	jr $ra
display:
	li $v0, 1
	syscall