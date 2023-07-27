.data
msg1: .asciiz "Enter first number: "
msg2: .asciiz "Enter second number: "
msg3: .asciiz "The GCD is: "

.text
.globl main

main:
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 5
	syscall
	move $s5, $v0		# a0 for input1
	
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 5
	syscall
	move $s6, $v0		# a1 for input2
	
	jal GCD		# GCD
	move $t0, $v0
	
	li $v0, 4
	la $a0, msg3
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 10	# exit
	syscall

GCD:			# GCD(s0, s1)
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	add $s0, $s5, $zero
	add $s1, $s6, $zero
	
	addi $t1, $zero, 0
	beq $s1, $t1, return1		#if s1==0: return
	
	add $s5, $zero, $s1
	div $s0, $s1
	mfhi $s6	# s6 for s0%s1
	
	jal GCD

end_GCD:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
return1:
	add $v0, $zero, $s0	# return v0 = s0 (n1)
	j end_GCD