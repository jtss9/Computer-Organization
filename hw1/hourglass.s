.data
msg1: .asciiz "Enter the number n = "
new_line: .asciiz "\n"
star: .asciiz "*"
space: .asciiz " "

.text

main:
		li      $v0, 4		# print msg
		la      $a0, msg1
		syscall
		
		li      $v0, 5		# read input
  		syscall  	
  		move    $t0, $v0    # t0 is input n
		
		# cal temp t2
		addi $t1, $t0, 1
		div $t1, $t1, 2
		mflo $t2
		rem $t3, $t0, 2
		beq $t3, 0, L0		# if n is even, skip -1
		addi $t2, $t2, -1	# temp is t2
L0:
		li $t4, 0	# t4 is i
L1_out:	
		bge $t4, $t2, end1
		li $t5, 0	# t5 is j for loop1
		li $t6, 0	# t6 is j for loop2
		li $t1, 0
		add $t1, $t1, $t0
		li $t3, 1
		mul $t3, $t4, 2
		sub $t1, $t1, $t3	# t1 is n-2i
		L1_in1:
			bgt $t5, $t4, L1_in2
			li $v0, 4
			la $a0, space
			syscall
			addi $t5, $t5, 1
			j L1_in1
		L1_in2:
			bge $t6, $t1, print_line
			li $v0, 4
			la $a0, star
			syscall
			addi $t6, $t6, 1
			j L1_in2
		print_line:
			li $v0, 4
			la $a0, new_line
			syscall
			addi $t4, $t4, 1
			j L1_out
			
end1:
		li $t4, 0		# t4 for i
		li $t3, 0
		addi $t3, $t0, 1
		div $t3, $t3, 2
		mflo $t4
		addi $t4, $t4, -1
L2_out:
		blt $t4, 0, end2
		li $t5, 0
		li $t6, 0
		li $t1, 0
		add $t1, $t1, $t0
		li $t3, 1
		mul $t3, $t4, 2
		sub $t1, $t1, $t3
		L2_in1:
			bgt $t5, $t4, L2_in2
			li $v0, 4
			la $a0, space
			syscall
			addi $t5, $t5, 1
			j L2_in1
		L2_in2:
			bge $t6, $t1, print_line2
			li $v0, 4
			la $a0, star
			syscall
			addi $t6, $t6, 1
			j L2_in2
		print_line2:
			li $v0, 4
			la $a0, new_line
			syscall
			addi $t4, $t4, -1
			j L2_out
end2:
