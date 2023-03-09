	.data
msg1:	.asciiz	"The random number is even."
msg2:	.asciiz	"The random number is odd."
	.text
main:
	li $v0, 42		# random number generator service code
	li $a1, 101		# upper-bound set to 101 (exclusive)
	syscall
	
	li $t0, 2		# number to divide by stored in $t0
	#div $a0, $t0		# divide our random number by 2
	#mfhi $t1		# store the remainder (if any) in $t1
	
	sll $a0, $a0, 31		# option 2: compare LSB to see if it was even
	
	# option 3: shift right 1 then left by 1 (lose last bit)
	# if the numbers are still the same afterwards then we know it was even, otherwise odd
	
	#beq $t1, $zero, evenN	# check if the remainder is zero (evenely divided)
	beq $a0, $zero, evenN
	la $a0, msg2		# it was odd so load that message
	j display		# jump to display and skip the evenN label
evenN:
	la $a0, msg1		# it was even so load that message
display:
	li $v0, 4		# display string service code
	syscall
	
	li $v0, 10		# exit application service code
	syscall