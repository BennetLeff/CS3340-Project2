.data 
	buffer: .space 20

.text
main:
	# Get user input
	li $v0, 8	# prepare to read input
	
	la $a0, buffer	# load byte space into address
	li $a1, 20	# allot the byte space for string
	
	move $t0, $a0	# move the string into $t0
	syscall

	addi $t1, $t1,   0 	# will be i for the ith element
	addi $t3, $zero, 1  	# holds the result of 31^i
	addi $t4, $zero, 31 	# hold the val to multiply $t2 by each iteration
	addi $t5, $zero, 0	# holds length of string
	addi $t6, $zero, 0  	# will store the final output
	addi $t7, $zero, 31 	# only purpose is holding const. 31
	addi $t8, $zero, 0	# hods s_i * 31^i before it's added to $t6
	addi $t9, $zero, 0xa  	# val of newline char

checkNull:
	lb   $t2, 0($t0)
	beqz $t2, end	 	# if the first char is 0 or newline, it's empty so
	beq  $t2, $t9, end	# we end the program, otherwise keep going with it
		
getLen:
	lb $t2, 0($t0)
	beq $t2, $t9, hashN
	
	addi $t0, $t0, 1	# update string index
	addi $t5, $t5, 1 	# increase len of string
	
	j getLen
			
hashN:				# assumes $t5 (str len) has been set
	lb   $t2, -1($t0)  	# t2 will hold the hex val of char at each interation
				# starts -1 index back because we read an extra index
				# for the new line character in getLen
	beqz $t5, printCalc	# goto end if we run out of chars

	mult $t2, $t3		# s_i * (31^i)
	mflo $t8		# store above calc in $t8
	add  $t6, $t6, $t8	# add calc to final calc in $t6

	# multiply by 31
	mult $t7, $t3 		# 31 ^ i
	mflo $t3	
			
	addi $t0, $t0, -1	# dec string address to read backwards
	addi $t5, $t5, -1       # subtract from loop counter
	j hashN		
		
printCalc:	
	add $a0, $zero, $t6
	li $v0, 1
	syscall
	
	# print a newline after printing the calculation
	addi $a0, $zero, 0xa
	addi $v0, $zero, 11	 
	syscall
	
	j main

end:
	li $v0, 10	# end program
	syscall	