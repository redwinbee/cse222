	.data
out1:	.asciiz	"Computer Architecture and Organization\n"
out2:	.asciiz	"SCCC – Computer Science Program\n"

	.text
main:
	# print the contents of out1 to the console.
	li	$v0,	4
	la	$a0,	out1
	syscall
	
	# print the contents of out2 to the console.
	la	$a0,	out2
	syscall
	
	# terminate the program.
	li	$v0,	10
	syscall