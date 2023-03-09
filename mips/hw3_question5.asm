	.data
prompt:	.asciiz	"Please enter two numbers: "
resul1:	.asciiz	"The sum of "
resul2:	.asciiz	", "
resul3:	.asciiz	", and "
resul4:	.asciiz	" is "
	.text
main:
	# prompt the user to enter two numbers
	li	$v0,	4
	la	$a0,	prompt
	syscall
	
	# grab the first number and store it in $t0
	li	$v0,	5
	syscall
	move	$t0,	$v0
	
	# grab the second number and store it in $t1
	li	$v0,	5
	syscall
	move	$t1,	$v0
	
	# grab the third number and store it in $t2
	li	$v0,	5
	syscall
	move	$t2,	$v0
	
	# calculate the result of adding both numbers together
	add	$t3,	$t0,	$t1
	add	$t4,	$t3,	$t2
	
	# display the result toe the console
	li	$v0,	4
	la	$a0,	resul1
	syscall
	
	li	$v0,	1
	move	$a0,	$t0
	syscall
	
	li	$v0,	4
	la	$a0,	resul2
	syscall
	
	li	$v0,	1
	move	$a0,	$t1
	syscall
	
	li	$v0,	4
	la	$a0,	resul3
	syscall
	
	li	$v0,	1
	move	$a0,	$t2
	syscall
	
	li	$v0,	4
	la	$a0,	resul4
	syscall
	
	li	$v0,	1
	move	$a0,	$t4
	syscall