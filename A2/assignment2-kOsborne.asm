#Program: Assignment 2
#Name: Kristen Osborne
#Date: March 17, 2014

.data

array:	.space 80
str1:	.asciiz"Please enter an array size: "
str2:	.asciiz"\nInvalid number. Please try again.\n"
str3: 	.asciiz"\nPlease enter a number to be inputted into the array: "
str4:	.asciiz" "
str5:	.asciiz"\n"
str6:	.asciiz"\nThe array contains: "
str7:	.asciiz"\nwe make it here"

.text

main:
	li $s1, 20	#used to verify size of array
	li $s3, 3	#checks divisibility
	la $t1, array	#load array into register

	jal readNum	
	add $s0, $a0, $0	#store array size in $a0

	add $a0, $s0, $0	#do this to use subroutine
	jal verifySize
	add $s2, $a0, $0	#store back into $s2
	add $s0, $a1, $0	#store size back into $s0

	beq $s2, $0, error
	bne $s2, $0, createArray
	
	print:
		add $a0, $s0, $0
		jal printArray
		add $s4, $a0, $a0

	add $a0, $s0, $0
	jal reverseArray

	jal printArray

	j exit
readNum:

	li $v0, 4	#print message
	la $a0, str1
	syscall

	li $v0, 5	#get size of array
	syscall

	add $a0, $v0, $0	#temporarily store array size in $a0

	jr $ra

verifySize:
	add $s0, $a0, $0	#store size back into s0

	sgt $s2, $s0, $0	#set s2 to 1 if size>0, else to 0
	beq $s2, $0, return	#if 0, go to return
	slt $s2, $s0, $s1	#set s2 to 1 if size<20, else to 0

return:
	add $a0, $s2, $0
	add $a1, $s0, $0

	jr $ra

createArray:
	li $s4, 0	#counter

	makingArray:

		jal readNum2
		add $s5, $a0, $0

		add $a0, $s5, $0
		jal checkNumPositive
		add $s6, $a0, $0
		add $s5, $a1, $0

		beq $s6, $0, makingArray	#if invalid, start over
		
		add $a0, $s5, $0
		jal divisibleBy3
		add $t2, $a0, $0
		add $s5, $a1, $0

		beq $t2, $0, makingArray	#if invalid, start again

		sw $s5, 0($t1)	#load num into array

		addi $s4, $s4, 1	#increment counter
		addi $t1, $t1, 4

		beq $s4, $s0, print #if counter<size

		j makingArray


error:
	li $v0, 4	#invalid array size
	la $a0, str2
	syscall

	j main	#start over

readNum2:
	li $v0, 4	#prints message
	la $a0, str3
	syscall

	li $v0, 5
	syscall
	
	add $a0, $v0, $0
	jr $ra

checkNumPositive:

	add $s5, $a0, $0	#store back into s5

	sgt $s6, $s5, $0	#set s6 to 1 if s5>0

	add $a0, $s6, $0
	add $a1, $s5, $0

	jr $ra	

divisibleBy3:
	add $s5, $a0, $0

	div $s5, $s3	#n/3
	mfhi $t0	#store remainder, dont need quotient
	
	seq $t2, $t0, $0 #set t2 to 1 if t0=0
	add $a0, $t2, $0
	add $a1, $s5, $0

	jr $ra

printArray:

	li $s4, 0	#counter
	la $t1, array
	add $s0, $a0, $0
	
	li $v0, 4	#print string
	la $a0, str6
	syscall

	printContents:

		beq $s4, $s0, printEnd

		li $v0, 1
		lw $a0, 0($t1)	#print content
		syscall

		li $v0, 4	#print space
		la $a0, str4
		syscall

		addi $s4, $s4, 1	#increment
		addi $t1, $t1, 4
		j printContents

printEnd:
	li $v0, 4	#endline
	la $a0, str5
	syscall

	add $a0, $s4, $0

	jr $ra

reverseArray:
	add $s0, $a0, $0
	la $t0, array
	li $s7, 2
	li $t0, 4
	li $s6, 0
	
	div $s0, $s7	#divide by 2
	mflo $t5

	mult $s0, $t0	#multiply by 4
	mfhi $t6
	mflo $t7
	add $t0, $t6, $t7	#store into $t0
	
	add $s4, $t1, $t0

	reverseContents:
		beq $s6, $t5, endReverse
		sub $s4, $s4, 4

		lw $t6, 0($t1)
		lw $t7, 0($s4)

		sw $t7, 0($t1)
		sw $t6, 0($s4)

		addi $t1, $t1, 4
		addi $s6, $s6, 1

		j reverseContents
endReverse:

	jr $ra

exit:
	li $v0, 10
	syscall