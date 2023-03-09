	.data
msg1a:	.asciiz	"(Method 1) The number "
msg1b:	.asciiz	"(Method 2) The number "
msg2:	.asciiz " is a power of 2."
msg3:	.asciiz	" isn't a power of 2."
num:	.word	0
	.text
main:
	# generate a random number and store it
	
	li $v0, 42	# rng service code
	li $a1, 11	# upper-bound (exclusive)
	syscall
	sw $a0, num	# store the random number
	
	# check if this number is a power of 2 using both methods
	
	jal is_pow_2_v1	# $a0 already contains the random number
	beqz $s0, is_not_pow_2	# return result wasn't a power of two
	# it was a power of two so print that message
	li $v0, 4
	la $a0, msg1a
	syscall
	li $v0, 1
	lw $a0, num
	syscall
	li $v0, 4
	la $a0, msg2
	syscall
	
	j next

	# Method 1: take for example the binary number 8 (1000), if we were to subtract 1 then we would get
	# the binary number 7 (0111). after this we then perform (1000 AND 0111) which would leave us with 0000, thus
	# telling us that the original number was a power of two. if there was any other bit set in the original number
	# (meaning it wasn't a power of two) then the number after performing the AND operation wouldn't be 0 and we could
	# conclude that it wasn't a power of two.
is_pow_2_v1:
	addi $t0, $a0, -1	# subtract 1 from the number to use as a bit-mask
	and $t1, $t0, $a0	# filter out 1 bits which, if the number is a power of 2, will leave us with 0
	beqz $t1, is_pow_2	# it this filtered number is 0 then we know the original was a power of 2
	li $s0, 0	# return value of false
	jr $ra	# end of function
is_pow_2:
	li $s0, 1	# return value of true
	jr $ra		# end of function


is_not_pow_2:
	# print the not power of 2 message
	li $v0, 4
	la $a0, msg1a
	syscall
	li $v0, 1
	lw $a0, num
	syscall
	li $v0, 4
	la $a0, msg3
	syscall

next:
	li $v0, 11	# print a new-line character
	li $a0, 10
	syscall
	
	jal is_pow_2_v2
	beq $s0, 1, is_pow_two_v2	# function is over so we check the result and branch
	# print the not power of 2 message
	li $v0, 4
	la $a0, msg1b
	syscall
	li $v0, 1
	lw $a0, num
	syscall
	li $v0, 4
	la $a0, msg3
	syscall
	
	j exit
is_pow_two_v2:
	# print the power of 2 message
	li $v0, 4
	la $a0, msg1b
	syscall
	li $v0, 1
	lw $a0, num
	syscall
	li $v0, 4
	la $a0, msg2
	syscall
	
	j exit
	# Method 2: counting the number of bits in the binary representation of the number; similar to method 1 where we
	# observe the bits in the number, except we count the number of 1 bits we find in the number and keep shifting until
	# all bits are processed. if at any point the number of bits exceeds 1 then we know the number can't be a power of 2.
is_pow_2_v2:
	lw $t0, num	# the number we're going to process
	move $t1, $zero	# counter
	
	# quick check to see if the number is 0
	seq $t4 $t0, $zero
	beq $t4, $zero, loop	# not 0 so continue the loop
	# is 0 so just return the result
	li $s0, 1
	jr $ra
	# loop to count the number of bits in the number
loop:
	andi $t2, $t0, 1	# AND filter with the number 1
	add $t1, $t1, $t2	# update the counter
	srl $t0, $t0, 1		# shift all bits to the right
	seq $t3, $t0, 0		# $t3 equal to the result of $t0 being 0 or not (1 true, 0 false)
	bnez $t0, loop		# continue the loop since we haven't exhausted all bits
	
	# loop's over so now we check what the result was
	seq $s0, $t1, 1		# we should only have 1 bit accounted for if the number was a power of 2
	jr $ra			# end of function
	
exit:
	# terminate program
	li $v0, 10
	syscall