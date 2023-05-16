	.data
ask_num:	.asciiz	"enter a number: "
res_str:	.asciiz	"result is: "
num:	.word	0
res:	.word	0
tmp:	.word	0
	.text
main:
	ask_loop:
		li $v0, 4
		la $a0, ask_num
		syscall
		li $v0, 5
		syscall
		sw $v0, num
		blez $v0, ask_loop
		
	move $s0, $v0
	li $v1, 1
	jal factorial
	sw $v1, res
	
	li $v0, 4
	la $a0, res_str
	syscall
	li $v0, 1
	lw $a0, res
	syscall
	
	j exit
exit:
	li $v0, 10
	syscall

#######################################################
factorial:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $s2, 1	# base case
	fac_loop:
		mul $v1, $v1, $s2
		subi $s0, $s0, 1
		sw $v1, tmp
		bgt $s0, $s2, fac_loop
	
	# housekeeping
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#######################################################
display:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $v0, 4
	la $a0, res_str
	syscall
	li $v0, 1
	lw $a0, tmp
	syscall
	
	# housekeeping
	lw $ra, 0($sp)
	addi $sp, $sp, 4