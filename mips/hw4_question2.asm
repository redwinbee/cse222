	.data
vx:	.word	0
msg1:	.asciiz	"The random number is "
msg2:	.asciiz	"(Method 1): 3x the random number is "
msg3:	.asciiz "(Method 2): 3x the random number is "
msg4:	.asciiz	"(Method 3): 3x the random number is "
	.text
main:
	# generate a random number in range [-100, 100] and print it to the screen
	
	li $a1, 201		# set the upper-bound
	li $v0, 42		# load rng service
	syscall
	
	add $a0, $a0, -100	# add the lower-bound
	sw $a0, vx		# store the random number into vx
	
	li $v0, 4		# load the print string service
	la $a0, msg1		# load the msg to print
	syscall
	
	lw $a0, vx		# load the stored random num
	li $v0, 1		# load print integer service
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	# take the number generated and use three different methods to calculate (3 * vx)
	
	# method 1 -- using the mult instruction
	lw $t0, vx		# load vx
	li $t1, 3		# load the number 3
	mult $t0, $t1		# multiply vx with 3
	mflo $t2		# move the product from $lo to $t2 (we know the result will always be 32-bit so we can ignore $hi)
	li $v0, 4		# load print string service
	la $a0, msg2		# load the msg to print
	syscall
	li $v0, 1		# load print integer service
	la $a0, 0($t2)		# load the product into $a0
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	# method 2 -- repeated addition
	lw $t0, vx		# load vx
	add $t1, $t0, $zero	# add zero to vx and set it to $t1
	add $t1, $t1, $t0	# add $t1 and vx and set it back to $t1
	li $v0, 4		# load print string service
	la $a0, msg3		# load the msg to print
	syscall
	li $v0, 1		# load print integer service
	la $a0, 0($t2)		# load the result into $a0
	syscall
	
	li $a0, 10		# load new line ASCII code
	li $v0, 11		# load print character service
	syscall
	
	# method 3 -- bit shifting multiplication
	# similar to repeated addition except we can skip a bunch of additions by bit shifting as much as we can first
	# for example, if we wanted to multiply some number x by 17 we can:
	#					16 = 2^4 (left shift by 4 bits) (multiply by 16)
	#					add x back to itself (multply by 17)
	lw $t0, vx
	sll $t1, $t0, 1		# shift $t0 to the left by 1 bit to get ($t0 * 2)
	add $t1, $t1, $t0	# add another $t1 to intself to get (($t0 * 2) + $t0)
	li $v0, 4		# load print string service
	la $a0, msg4		# load the msg to print
	syscall
	li $v0, 1		# load print integer service
	la $a0, 0($t1)		# load the result into $a0
	syscall		