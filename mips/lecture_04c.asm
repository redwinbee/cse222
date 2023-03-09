	.data
msg:	.asciiz	"the power of this number is "
	.text
main:
	# given a number n (such as 256), find the two's power of this number and display it
	
	li $s0, 1	# init power
	li $s1, 0	# init the index
	li $s2, 1024	# init the number we want to find the two's power of
	
loop:
	beqz $s2, end
	
	j loop
end:
	
	
	li $v0, 35
	la $a0, ($t0)
	syscall