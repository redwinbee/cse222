	.data
arr:	.space	48	# store 12 integers in array space
msg:	.asciiz	"The maximum element in the array is "
max:	.word	0

	.text
main:
	li $t0, 12	# init the size of the array
	li $t1, 0	# init the counter
	la $t2, arr	# init the base address
	loop:
		jal gen_num	# generate number and get result in $s0
		slt $t3, $t1, $t0	# check if 'i' < size and set this result to $t3 (1 or 0)
		beq $t3, $zero, exit_loop	# compare to 0 and if it is then display the number since we're done
	
		sw $a0, 0($t2)	# store this number in the array
		addi $t1, $t1, 1	# increment the index by 1
		addi $t2, $t2, 4	# increment the address of the array by 4 bytes (since we're storing integers) so we store the next number in the correct place
		j loop	# continue the loop
		
exit_loop:
	la $a0, arr	# load the base address of the array
	li $a1, 12	# load the size of the array
	jal max_elem	# find the largest number in this array
	sw $s0, max	# save the max to max variable
	
	# print the max value of the array
	li $v0, 4	# print string service
	la $a0, msg	# load the message
	syscall
	li $v0, 1	# print integer service
	lw $a0, max	# load the max number
	syscall
	li $v0, 11	# print character service
	li $a0, 10	# line feed
	syscall
	
	j exit
gen_num:
	li $v0, 42	# rng service code
	li $a1, 11	# upper-bound
	syscall
	addi $a0, $a0, -10
	move $s0, $a0	# move it to the return result
	jr $ra
max_elem:
	li $t0, 1	# counter
	li $s0, -11	# init the current maximum
	mloop:
		slt $t1, $t0, $a1	# check if we finished the array
		beq $t1, $zero, mexit_loop	# if we're done then we can return  whatever is the current largest
		
		# get the current element of the array and check if it is larger than the current max, if not then loop again
		la $t2, 0($a0)	# current element
		sge $t3, $t2, $s0	# current > $s0 then $t3 is 1 otherwise 0
		
		addi $t0, $t0, 1	# update the counter
		addi $a0, $a0, 4	# update the offset
		
		beq $t3, 1, mloop	# loop again, no change
		# but it is here so we update the value
		la $s0, ($t2)	# update the max
	mexit_loop:
	jr $ra
exit:
	li $v0, 10
	syscall