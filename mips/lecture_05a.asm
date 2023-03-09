	.data
arr:	.space	40	# tell MIPS to reserve 40 bytes of contiguous memory space
size:	.word	10	# the size (in bytes) of the data we want to store in the array we defined
	.text
main:
	# initialize the array with random numbers in range [0, 20]
	
	lw $t0, size	# store the size of the array in $t0
	li $t1, 0	# index 'i'
	la $t2, arr	# base address of the array
loop:
	slt $t3, $t1, $t0	# check if 'i' < size and set this result to $t3 (1 or 0)
	beq $t3, $zero, display	# compare to 0 and if it is then display the number since we're done
	
	# generate a random number
	li $v0, 42	# rng service code
	li $a1, 21	# upper-bound of the rng (exclusive)
	syscall
	sw $a0, 0($t2)	# store this number in the array
	addi $t1, $t1, 1	# increment the index by 1
	addi $t2, $t2, 4	# increment the address of the array by 4 bytes (since we're storing integers) so we store the next number in the correct place
	j loop	# continue the loop
display:
	# display the contents of this array
	
	li $t1, 0	# index 'i' (reset)
	la $t2, arr	# base address of the array (reset)
	
dloop:
	slt $t3, $t1, $t0	# check if 'i' < size and set this result to $t2
	beq $t3, $zero, exit	# check if we continue the loop or not, otherwise go to exit
	li $v0, 1	# display integer service
	lw $a0, 0($t2)	# load the word (integer) into the argument
	syscall
	li $v0, 11	# print character service code
	la $a0, 32	# print a space character
	syscall
	addi $t1, $t1, 1	# increment the index by 1
	addi $t2, $t2, 4	# increment the address
	j dloop	# continue the display loop
exit:
	li $v0, 10	# terminate the program
	syscall