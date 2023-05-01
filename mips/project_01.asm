	.data
opt1:	.asciiz	"1) Binary	-> Hexadecimal & Decimal\n"
opt2:	.asciiz	"2) Hexadecimal	-> Binary & Decimal\n"
opt3:	.asciiz	"3) Decimal	-> Binary & Hexadecimal\n"
opt4:	.asciiz	"4) Exit\n"
prmpt:	.asciiz	"Please select an option: "
note:	.asciiz	"\n**The value entered must be 8 characters long**"
req:	.asciiz	"\nPlease enter the value to convert: "
hex:	.asciiz	"	Hexadecimal: "
bin:	.asciiz	"	Binary: "
dec:	.asciiz	"	Decimal: "
buf:	.space	9	# 8 bytes + 1 null terminator
tmp:	.word	0
	.text
main:
	menu:
		# print the menu options and ask user to select one
		li $v0, 4	# print string service
		la $a0, opt1	# option 1
		syscall
		la $a0, opt2	# option 2
		syscall
		la $a0, opt3	# option 3
		syscall
		la $a0, opt4	# option 4
		syscall
		la $a0, prmpt	# prompt
		syscall
		li $v0, 12	# read character service
		syscall
		
		# branch away or ask for selection again if it was invalid
		beq $v0, 49, bin_to_hex_and_dec	# selection 1
		beq $v0, 50, hex_to_bin_and_dec	# selection 2
		beq $v0, 51, dec_to_bin_and_hex	# selection 3
		beq $v0, 52, exit		# selection 4
		li $v0, 11			# print character service
		li $a0, 10			# ASCII 'Line Feed'
		syscall
		j menu				# jump to the menu again
		
		# handle binary -> hex & decimal conversion
		bin_to_hex_and_dec:
			# get the string that we'll be converting from the user
			li $v0, 4
			la $a0, note
			syscall
			li $v0, 4	# print string service
			la $a0, req	# load the string into the argument
			syscall
			li $v0, 8	# read string service
			la $a0, buf	# load the buffer into $a0
			li $a1, 9	# load the max size to read
			syscall
			
			# ensure the string being inputted is a valid binary number
			jal is_binary	# check if the string is a binary number
			beq $v0, 0, bin_to_hex_and_dec	# if it wasn't valid then get another number
			
			# convert to hexadecimal and decimal
			la $a0, buf	# load the buffer into $a0
			jal bin_to_hex	# convert from binary -> hexadecimal
			move $t9, $v0	# move the result to the service argument
			li $v0, 11	# print character service
			li $a0, 10	# ASCII code 'line feed'
			syscall
			li $v0, 4	# print string service
			la $a0, hex	# hex message
			syscall
			li $v0, 34	# print hexadecimal service
			move $a0, $t9	# move the result back to the argument for the print service
			syscall
			move $t9, $a0	# move it back to display the decimal message
			li $v0, 11	# print character service
			li $a0, 10	# ASCII code 'line feed'
			syscall
			li $v0, 4	# print string service
			la $a0, dec	# dec message
			syscall
			li $v0, 1	# print integer service
			move $a0, $t9	# move the result back to the argument
			syscall
			
			# end the program
			j exit
		hex_to_bin_and_dec:
			# get the hexadecimal string we're going to convert
			li $v0, 4
			la $a0, note
			syscall
			li $v0, 4
			la $a0, req
			syscall
			li $v0, 8	# read string service
			la $a0, buf	# load the buffer into $a0
			li $a1, 9	# load the max size to read
			syscall
			
			
			# ensure the string provided is valid and ask for another if it isn't
			jal is_hex
			beq $v0, 0, hex_to_bin_and_dec
			
			# convert to binary and decimal
			la $a0, buf	# load the string into the argument
			jal hex_to_bin	# convert from hexadecimal -> binary
			move $t9, $v0	# move the value to a temp register for a little while
						
			li $v0, 11	# print character service
			li $a0, 10	# ASCII code 'line feed'
			syscall
			li $v0, 4	# print string service
			la $a0, bin	# bin message
			syscall
			li $v0, 35	# print binary service
			move $a0, $t9	# move the result back to the argument for the print service
			syscall
			move $t9, $a0	# move it back to display the decimal message
			li $v0, 11	# print character service
			li $a0, 10	# ASCII code 'line feed'
			syscall
			li $v0, 4	# print string service
			la $a0, dec	# dec message
			syscall
			li $v0, 1	# print integer service
			move $a0, $t9	# move the result back to the argument
			syscall
			# end the program
			j exit
		dec_to_bin_and_hex:
			li $v0, 4
			la $a0, note
			syscall
			li $v0, 4
			la $a0, req
			syscall
			li $v0, 8	# read string service
			la $a0, buf	# load the buffer into $a0
			li $a1, 9	# load the max size to read
			syscall
			
			# ensure the string provided is a vavlid decimal number (integer)
			jal is_decimal
			beqz $v0, dec_to_bin_and_hex
			
			# convert to binary and hexadecimal
			la $a0, buf
			jal string_to_dec
			move $t9, $v0
			li $v0, 11	# print character service
			li $a0, 10	# ASCII code 'line feed'
			syscall
			li $v0, 4	# print string service
			la $a0, hex	# hex msg
			syscall
			li $v0, 34	# print hexadecimal service
			move $a0, $t9	# move the result back to $a0
			syscall
			move $t9, $a0	# move it back to $t9 temporarily
			li $v0, 11	# print character service
			li $a0, 10	# ASCII code 'line feed'
			syscall
			li $v0, 4	# print string service
			la $a0, bin	# bin msg
			syscall
			li $v0, 35	# print binary service
			move $a0, $t9	# move it back to the argument
			syscall
			
			# end the program
			j exit
exit:
	li $v0, 10
	syscall
##################################################################################
# checks if a given string is a valid representation of a binary number. Binary
# numbers can only have 1's and 0's as the characters of a string.
# $a0 = string to check
# $v0 = result (1 = true, 0 = false)
is_binary:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	is_bin_loop:
		lb $t0, ($a0)			# load the current byte into $t0
		beq $t0, $zero, is_bin_exit	# exit the loop if we're at the end of the string
		bne $t0, 48, check_one		# current charcter isn't 0, check if it's 1
		addi $a0, $a0, 1		# it was 0 so check the next character
		j is_bin_loop			# loop again
		check_one:
			bne $t0, 49, is_bin_invalid	# invalid binary number
			addi $a0, $a0, 1		# still valid, advance to the next character
			j is_bin_loop			# check next character
		is_bin_invalid:
			li $v0, 0	# set result to false
			j is_bin_exit	# jump to exit
is_bin_exit:
	# housekeeping
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
##################################################################################
# $a0 = binary string to convert
# $v0 = hexadecimal value of the string
bin_to_hex:
	# housekeeping 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $v0, 0	# init the integer value
	move $t0, $a0	# init $t0 to the binary string
	bh_loop:
		lbu $t1, ($t0)			# load the current byte from the string
		beq $t1, $zero, bh_loop_end	# end of the string so we exit loo4
		sub $t1, $t1, 0x30		# convert the ASCII digit to an integer value
		sll $v0, $v0, 1			# shift the integer to the left (logically) by 1 bit
		add $v0, $v0, $t1		# add the binary digit to the integer value
		addi $t0, $t0, 1		# advance to the next character in the string
		j bh_loop			# loop again
	bh_loop_end:
		# housekeeping
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
##################################################################################
# checks if a give string value is a valid hexadecimal number, note that for simplicity's
# sake this string is not in the standard form of "0xABCD" but rather just "ABCD". similar
# to the "is_bin" check we determine that each character is either from 0-9 or A-F.
is_hex:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $v0, 0	# init the result
	is_hex_loop:
		# valid characters
		lb $t0, ($a0)		# load the current byte into $t0
		beqz $t0, is_hex_loop_exit
		sgtu $t1, $t0, 47	# set if $t0 > 47 [0..
		slti $t2, $t0, 58	# set if $t0 < 58 [0..9]
		sgtu $t3, $t0, 64	# set if $t0 > 64 [A..
		slti $t4, $t0, 71	# set if $t0 < 71 [A..F]
		sgtu $t5, $t0, 96	# set if $t0 > 96 [a..
		slti $t6, $t0, 103	# set if $t0 < 103 [a..f]
		
		# AND/OR checks
		and $t7, $t1, $t2
		and $t8, $t3, $t4
		and $t9, $t5, $t6
		or $t1, $t7, $t8
		or $v0, $t1, $t9
		
		# check if we can break early
		beqz $v0, is_hex_loop_exit
		addi $a0, $a0, 1	# advance to the next character
		j is_hex_loop
	is_hex_loop_exit:
		# housekeeping
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
##################################################################################
# converts a given hexadecimal string to binary by extracting 4 bits at a time
# and converting that to binary and saving it to a register
# $a0 = hexadecimal string to convert
# $v0 = binary representation of the hex string
hex_to_bin:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $v0, 0	# init the result
	move $t0, $a0	# init the hexadecimal string address
	hb_loop:
		lb $t1, ($t0)			# laod the current byte into $t1
		beq $t1, $zero, hb_loop_exit	# nothing left to process in the string
		andi $t2, $t1, 0x0F		# extract the lower 4 bits
		sll $v0, $v0, 4			# shift the result by 4 bits to the left (logical)
		or $v0, $v0, $t2		# merge the extracted bits with the result
		addi $t0, $t0, 1		# advance to the next character
		j hb_loop			# continue the loop
	hb_loop_exit:
		# housekeeping
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
##################################################################################
is_decimal:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $v0, 0	# init the result
	is_decimal_loop:
		lb $t0, ($a0)	# load the current byte into $t0
		beqz $t0, is_decimal_loop_end
		sgtu $t1, $t0, 47	# set if $t0 > 47 [0..
		slti $t2, $t0, 58	# set if $t0 < 58 [0..9]
		and $v0, $t1, $t2	# check if $t0 is in range [0..9]
		beqz $v0, is_decimal_loop_end	# end early if an invalid character is found anywhere
		addi $a0, $a0, 1	# advance to the next character
		j is_decimal_loop
	is_decimal_loop_end:
		# housekeeping
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
##################################################################################
string_to_dec:
	# housekeeping
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# implementation
	li $v0, 0	# init the final result
	sd_loop:
		lb $t0, ($a0)		# load the current character
		beqz $t0, sd_loop_exit	# exit when we reach of the end of the string
		subi $t0, $t0, 48	# conver to ASCII digit
		mul $v0, $v0, 10	# multiply the result by 10
		add $v0, $v0, $t0	# add the current num to the result
		addi $a0, $a0, 1	# advance to the next character
		j sd_loop		# loop again
	sd_loop_exit:
		# housekeeping
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
##################################################################################