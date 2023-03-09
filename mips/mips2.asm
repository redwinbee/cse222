	.data
msg1:	.asciiz	"Enter 2 numbers: "
res:	.word	0


	.text
main:
	# prompt the user to enter two numbers
	
	li $v0, 4
	la $a0, msg1
	syscall
	
	# user enters two numbers
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	# do addition on both numbers
	
	add $t2, $t0, $t1
	
	# display sum
	
	li $v0, 1
	move $a0, $t2 
	syscall
	
	# store sum in "res"
	
	la $a0, res
	sw $t2, 0($a0)
	
	# terminate
	li $v0, 10
	syscall
	