	.data
rand1:	.word	0
r1_dec:	.asciiz	"rand1(decimal): "
r1_hex:	.asciiz	"rand1(hexadec): "
r1_bin:	.asciiz	"rand1(binary): "
rand2:	.word	0
r2_dec:	.asciiz	"rand2(decimal): "
r2_hex:	.asciiz	"rand2(hexadec): "
r2_bin:	.asciiz	"rand2(binary): "
quot:	.asciiz "quotient: "
rema:	.asciiz	"remainder: "
	.text
main:
	# generate two random numbesr in range [100, 1000] and store them
	
	li $a1, 1001		# set the upper-bound
	li $v0, 42		# load rng service
	syscall
	add $a0, $a0, 100	# add the lower-bound
	sw $a0, rand1		# store the random number into rand1
	
	syscall			# call the rng service for another rand num
	add $a0, $a0, 100	# add the lower-bound
	sw $a0, rand2		# store the random number into rand1
	
	# print rand1 as decimal, hexadecimal, and binary
	
	lw $t0, rand1		# load rand1 into $t0 for later use
	
	li $v0, 4		# load print string service
	la $a0, r1_dec		# load string to print
	syscall
	li $v0, 1		# load print number as decimal service
	la $a0, 0($t0)		# copy the rand num into the argument for the current service
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	li $v0, 4		# load print string service
	la $a0, r1_hex		# load string to print
	syscall
	li $v0, 34		# load print number as hexadecimal service
	la $a0, 0($t0)		# load number to print into $a0
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	li $v0, 4		# load print string service
	la $a0, r1_bin		# load string to print
	syscall
	li $v0, 35		# load print number as hexadecimal service
	la $a0, 0($t0)		# load number to print into $a0
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	# print rand2 as decimal, hexadecimal, and binary
	
	lw $t1, rand2		# load rand1 into $t0 for later use
	
	li $v0, 4		# load print string service
	la $a0, r2_dec		# load string to print
	syscall
	li $v0, 1		# load print number as decimal service
	la $a0, 0($t1)		# copy the rand num into the argument for the current service
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	li $v0, 4		# load print string service
	la $a0, r2_hex		# load string to print
	syscall
	li $v0, 34		# load print number as hexadecimal service
	la $a0, 0($t1)		# load number to print into $a0
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	li $v0, 4		# load print string service
	la $a0, r2_bin		# load string to print
	syscall
	li $v0, 35		# load print number as hexadecimal service
	la $a0, 0($t1)		# load number to print into $a0
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	# find and print the difference between these two numbers
	
	sub $t2, $t0, $t1
	
	li $v0, 1		# print integer service
	la $a0, 0($t0)		# load $t0 to be printed
	syscall
	
	li $v0, 11		# print character service
	li $a0, 32		# ASCII code ' '
	syscall
	
	li $a0, 45		# ASCII code '-'
	syscall
	
	li $a0, 32		# ASCII code ' '
	syscall
	
	li $v0, 1		# print integer service
	la $a0, 0($t1)		# load $t1 to be printed
	syscall
	
	li $v0, 11		# print character service
	li $a0, 32		# ASCII code ' '
	syscall
	
	li $a0, 61		# ASCII code '='
	syscall
	
	li $a0, 32		# ASCII code ' '
	syscall
	
	li $v0, 1		# print integer service
	la $a0, 0($t2)		# load $t2 to be printed
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	# divide the first random number by 7 and display the quotient and remainder
	
	li $t9, 7		# store the divisor in $t9
	
	div $t0, $t9		# perform divison ($t0 / $t9)
	mflo $t3			# move quotient to $t3
	mfhi $t4			# move remainder to $t4
	
	li $v0, 4
	la $a0, quot
	syscall
	li $v0, 1
	la $a0, 0($t3)
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	li $v0, 4
	la $a0, rema
	syscall
	li $v0, 1
	la $a0, 0($t4)
	syscall