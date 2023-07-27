.data
msg1: .asciiz "Enter the number n = "
msg2: .asciiz " is a prime"
msg3: .asciiz " is not a prime, the nearest prime is"
space: .asciiz " "

.text
.globl main

main:
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0	# save the number n in s0
	
	jal prime
	move $s1, $v0	#save the result in s1
	beq $s1, $zero, not_prime
	move $a0, $s0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 10	# exit
	syscall

prime:
	li $t1, 1
	li $v0, 0	# return value
	beq $s0, $t1, ret0	# if n==1: return
	li $t2, 2	# t2 for i
	loop1:
		li $t3, 1
		mul $t3, $t2, $t2
		bgt $t3, $s0, ret1
		div $s0, $t2
		mfhi $t4
		beq $t4, $zero, ret0
		addi $t2, $t2, 1
		j loop1
	ret1:
		addi $v0, $v0, 1
		jr $ra
	ret0:
		jr $ra

not_prime:
	move $a0, $s0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, msg3
	syscall
	
	li $t5, 1	# t5 for i
	add $s4, $s0, $zero	# copy n in s4
	li $s5, 0	# s5 for flag
	loop:
		sub $t6, $s4, $t5
		move $s0, $t6
		jal prime
		move $s1, $v0
		bne $s1, $zero, print_num
		if2:
			add $t6, $s4, $t5
			move $s0, $t6
			jal prime
			move $s1, $v0
			bne $s1, $zero, print_num2
		fl:
			beq $s5, $zero, loop
	
	
	li $v0, 10	# exit
	syscall
	
print_num:
	li $v0, 4
	la $a0, space
	syscall
	move $a0, $s0
	li $v0, 1
	syscall
	addi $s5, $s5, 1
	j if2
	
print_num2:
	li $v0, 4
	la $a0, space
	syscall
	move $a0, $s0
	li $v0, 1
	syscall
	addi $s5, $s5, 1
	j fl