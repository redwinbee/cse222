	.data

	.text
main:
	# generate a random number and pass it to our 'func1' to display which number we generated
	
	li $v0, 42	# rng service code
	li $a1, 101	# upper-bound of rng
	syscall
	jal func1	# call the function and set $ra to the instruction address after this one so we know where to return to

	li $v0, 10	# terminate the program -- this is where we end up after calling 'jr $ra' in the function body
	syscall
func1:
	addi $a0, $zero, 88
	jal func2
	jr $ra
func2:
	li $v0, 1	# display integer service code
	syscall
	jr $ra		# go to the next instruction defined after the function was called
