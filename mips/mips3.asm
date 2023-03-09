	.data
var1:	.word	10
var2:	.word	20

	.text
main:
	# read both variables first
	
	la $a1, var1
	lw $a0, 0($a1)
	li $v0, 1
	syscall
	move $t0, $a0
	
	la $a1, var2
	lw $a0, 0($a1)
	li $v0, 1
	syscall
	move $t1, $a0
	
	# swap the values
	
	
	
	li $v0, 10
	syscall