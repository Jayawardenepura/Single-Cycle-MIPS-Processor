# Created in Mars simulator for MIPS architecture

#Bubble sort implemented in MIPS assembler

# If the memory file contains sorted array - architecture works completely
# If you wish to compile the code in Mars simulator - use " Compact, Data at Address 0" for good portable in custom implementation

.data

	#main array with positive integers
	myArray: .space 24
	
.text
	
	#save values in the main registers
	ori $s0, $zero, 4
	ori $s1, $zero, 10
	ori $s2, $zero, 12
	ori $s3, $zero, 9
	ori $s4, $zero, 1
	ori $s5, $zero, 99
	
	
	#save values from registers to memory for future comparing
	ori $t0, $zero, 32

	sw $s0, myArray($t0)
		addi $t0, $t0, 4
	sw $s1, myArray($t0)
		addi $t0, $t0, 4
	sw $s2, myArray($t0)
		addi $t0, $t0, 4
	sw $s3, myArray($t0)
		addi $t0, $t0, 4
	sw $s4, myArray($t0)
		addi $t0, $t0, 4
	sw $s5, myArray($t0)
		addi $t0, $t0, 4	
	
	# Index $t0
	addi $t0, $zero, 0
	
	#save the same values to memory for sorting
	sw $s0, myArray($t0)
		addi $t0, $t0, 4
	sw $s1, myArray($t0)
		addi $t0, $t0, 4
	sw $s2, myArray($t0)
		addi $t0, $t0, 4
	sw $s3, myArray($t0)
		addi $t0, $t0, 4
	sw $s4, myArray($t0)
		addi $t0, $t0, 4
	sw $s5, myArray($t0)
		addi $t0, $t0, 4
				
	ori $t3, $t3, 0 #0->rising, 1->falling type of sorting
	
	ori $t1,$t1, 20 #size array 6(elements)*4(bytes) = 24 <- in
	ori $t2,$t2, 24 #size array 6-1(elements)*4(bytes) = 20 <- out
	
	ori $t0, $zero, 0
	
	ori $t5, $zero, 0
	ori $t6, $zero, 0			
	
	out_loop:
						
		#~~~~~~~ INPUT CODE ~~~~~~~~~~#
		ori $t5, $zero, 0 #sub_i++
		ori $t6, $zero, 0 #sub_i+++	
		in_loop:
		####SUB count in
		addi $t6, $t6, 4 #sub_i++
		###

		# SWAP manipulations
		
		lw $t7, myArray($t5)	# temp = a[0]
		lw $t8, myArray($t6) # b[0] = val
		
		slt $t4, $t7, $t8
		beq $t4, $t3, non_sorting
		
		sw $t8, myArray($t5)	#a[0] = b[0]
		sw $t7, myArray($t6) 	#b[0] = temp
		 	
		non_sorting: 		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		addi $t5, $t5, 4 #sub_i++
		bne $t5, $t1, in_loop
		
		addi $t0, $t0, 4 # i++							
		bne $t0, $t2, out_loop #output loop

	#finish:
		#j finish