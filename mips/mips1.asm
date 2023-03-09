	.data
var1:	.word	10
msg:	.asciiz	"Hello, World"
msg2:	.space	64
msg3:	.asciiz	"Number captured: "

	.text
start:	li $v0, 4
	la $a0, msg
	syscall
	
	
	la $a1, var1
	lw $a0, 0($a1)
	li $v0, 1
	syscall
	
	
	li $v0, 5
	syscall
	
	
	li $v0, 8
	la $a0, msg2
	li $a1, 64
	syscall
	
	li $v0, 4
	la $a1, msg2
	syscall
	
	li $v0, 10
	syscall