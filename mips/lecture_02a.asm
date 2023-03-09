	.data
	
	.text
main:
	# if you see 3 registers in an instruction then it's definitely an R-Type instruction
	li $t0, 10
	li $t1, 20
	add $t2, $t1, $t0
	
	# pseudo-instruction since this number is too big to fit inside the instruction
	# MIPS will convert this to BASIC and split this into two instructions and handle it for us
	# so that we can store this number in the specified register
	li $t3, 0xABCD1234
	
	addi $t0, $0, 0xFFFFFFFF
	
	# display as decimal number
	li $a0, 100
	li $v0, 1
	syscall
	
	# display as hexadecimal number
	li $v0, 34
	syscall
	
	# display as binary number
	li $v0, 35
	syscall
	
	# generate a random number, service code 42. number stored in $a0
	li $v0, 42
	li $a1, 1000 # upper-bound for random number generation
	syscall
	
	# multiplication -- since MIPS is a 32-bit architecture instruction set and multiplication leads to numbers that can only
	# be fully represented using 64-bit register, we save the result in two locations: hi and lo
	li $s0, 9
	li $s1, 4
	mult $s0, $s1
	# after the multiplication we grab the hi and lo and store the values in our own registers we specify
	mfhi $s2
	mflo $s3
	
	
	# division -- handled in a similar way to multiplication since we get two results: quotient (lo) and remainder (hi)
	div $s0, $s1
	mfhi $s2
	mflo $s3
	
	