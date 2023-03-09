	.data
big:	.asciiz	"Big-Endian system detected."
lit:	.asciiz	"Little-Endian system detected."
tmp:	.word	0
	.text
main:
	li $t0, 0xABCD1234	# init sample data
	sw $t0, tmp		# store the sample data
	lb $t1, tmp		# load a single byte from tmp to check against our markers
	li $s0, 0xAB		# big-endian marker
	li $s1, 0x34		# little-endian marker
	
	beq $t1, $s0, big_end	# branch to big_end if we get the big endian marker
	
little_end:
	li $v0, 4		# print string service code
	la $a0, lit		# load the little-endian msg
	syscall
	j exit
	
big_end:
	li $v0, 4		# print string service code
	la $a0, big		# load the big-endian msg
	syscall
	j exit

exit:
	li $v0, 10		# terminate program execution
	syscall
