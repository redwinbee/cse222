	.data
sun:	.asciiz	"Sunday.\n"
mon:	.asciiz	"Monday.\n"
tue:	.asciiz	"Tuesday.\n"
wed:	.asciiz	"Wednesday.\n"
thur:	.asciiz	"Thursday.\n"
fri:	.asciiz	"Friday.\n"
sat:	.asciiz "Saturday.\n"
	.text 
main:
	# generate a random number to match to a random day of the week
	li $v0, 42
	li $a1, 7
	syscall
	
	# branch to the corresponding day of the week. since the conditions of this program are that
	# we will always generate a number in range [0, 6] we don't need to handle any default case
	# to exit the program. simply jump to the exit in each branch after we print the string.
	beq $a0, 0, b_sun
	beq $a0, 1, b_mon
	beq $a0, 2, b_tue
	beq $a0, 3, b_wed
	beq $a0, 4, b_thur
	beq $a0, 5, b_fri
	beq $a0, 6, b_sat

	# it's interesting to see the similarities between this structure and switch statements
	# in java. 'j exit' is very similar to 'break;' and the labels are just the cases.
b_sun:
	li $v0, 4
	la $a0, sun
	syscall
	j exit
b_mon:
	li $v0, 4
	la $a0, mon
	syscall
	j exit
b_tue:
	li $v0, 4
	la $a0, tue
	syscall
	j exit
b_wed:
	li $v0, 4
	la $a0, wed
	syscall
	j exit
b_thur:
	li $v0, 4
	la $a0, thur
	syscall
	j exit
b_fri:
	li $v0, 4
	la $a0, fri
	syscall
	j exit
b_sat:
	li $v0, 4
	la $a0, sat
	syscall
	j exit

exit:
	li $v0, 10	# terminate
	syscall