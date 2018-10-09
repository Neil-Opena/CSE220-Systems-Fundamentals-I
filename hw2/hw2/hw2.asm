# Neil Opena
# nopena
# 110878452

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

print_car:
	# $a0 --> address of car name to print
	#prints vin number 
	li $v0, 4 
	syscall
	jr $ra

print_year:
	# $a0 --> year integer
	li $v0, 1
	syscall
	li $a0, '\n'
	li $v0, 11
	syscall
	jr $ra

### Part I ###
index_of_car:
	#the function takes the following arguments in order:
	# cars --> an array of car structs
	# $a0 = starting address of car sturcts array

	# length --> the length of the cars array (how many structs are stored in the array)
	# $a1 = length of cars array
	ble $a1, 0, index_of_car_error_part_1 #length less <= to 0

	# start_index --> the index at which to start the search
	# $a2 = start_index
	blt $a2, 0, index_of_car_error_part_1 #start index < 0
	bge $a2, $a1, index_of_car_error_part_1 #start index >= length

	# year --> the year of manufacture
	# $a3 = year
	blt $a3, 1885, index_of_car_error_part_1 #year < 1885

	# traverse the array by 16 bytes
	move $t0, $a2 # t0 = index of car (to return later)

	# t1 = used to hold current byte address
	move $t1, $a0  # add starting address

	# t2 = used to get starting index and multiply by 16 to 'skip' previous indices
	move $t2, $a2 
	sll $t2, $t2, 4 # multiply by 16 bytes (the starting index)
	add $t1, $t1, $t2 

	addi $t1, $t1, 12 # add 4 for vin, 4 for make, 4 for model, but only load 2

	# changed t2 to hold the year
	li $t2, 0 

	traverse_part_1:
		bge $t0, $a1, index_of_car_error_part_1 # not found car with given year
		# current index NOT greater than length:

		lhu $t2, ($t1)
		beq $t2, $a3, found_index_part_1

		addi $t1, $t1, 16 #add 16 bytes --> go to the next car's year
		addi $t0, $t0, 1
		j traverse_part_1
	
	found_index_part_1:
		# v0 --> the index of the located car
		move $v0, $t0
		jr $ra

	index_of_car_error_part_1:
		li $v0, -1
		jr $ra
	

### Part II ###
strcmp:

	# a0 = pointer to the first string
	# a1 = pointer to the second string

	move $t0, $a0 # t0 = points to current string 1 byte address
	lbu $t1, ($t0)  # t1 = current string 1 byte

	move $t2, $a1 # t2 = points to current string 2 byte address
	lbu $t3, ($t2) # t3 - current string 2 byte

	li $t4, 0 # t4 = difference (to return later)

	beqz $t1, str1_empty_part2
	beqz $t3, str2_empty_part2

	# loop through both strings, if one reaches the null terminator, then don't continue to traverse
	traverse_part_2:
		beqz $t1, substr1_check_part2
		beqz $t3, substr2_check_part2

		sub $t4, $t1, $t3 # str1[i] - str2[j]
		bne $t4, $0, done_part_2

		addi $t0, $t0, 1 # move on to next character address
		lbu $t1, ($t0)

		addi $t2, $t2, 1 # move on to next character address
		lbu $t3, ($t2)
		j traverse_part_2

		substr1_check_part2:
			beqz $t3, done_part_2
			sub $t4, $0, $t3
			j done_part_2
		
		substr2_check_part2:
			beqz $t1, done_part_2
			sub $t4, $t1, $0
			j done_part_2

	str1_empty_part2:
		# traverse string 2, add -1 to t4 per character
		beqz $t3, done_part_2

		addi $t4, $t4, -1
		addi $t2, $t2, 1
		lbu $t3, ($t2)
		j str1_empty_part2

	str2_empty_part2:
		# traverse string 1, add 1 to t4 per character
		beqz $t1, done_part_2

		addi $t4, $t4, 1
		addi $t0, $t0, 1
		lbu $t1, ($t0)
		j str2_empty_part2

	done_part_2:
		move $v0, $t4
		jr $ra

	# return in v0 the difference in ASCII value

### Part III ###
memcpy:

	# a0 = address of src
	# a1 = address of dest, can assume that dest is at least n bytes
	# a2 = n (must be greater than 0)

	ble $a2, $0, failure_part_3

	move $t0, $a0 # t0 = address for each src character
	move $t1, $a1 # t1 = address for each dest character
	li $t2, 0 # t2 = current index

	li $t3, 0 # t3 = byte holder 

	copy_byte_part_3:
		bge $t2, $a2, success_part_3
		lbu $t3, ($t0)
		sb $t3, ($t1)

		addi $t0, $t0, 1
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		j copy_byte_part_3

	success_part_3:
		li $v0, 0
		jr $ra
	failure_part_3:
		li $v0, -1
		jr $ra


### Part IV ###
insert_car:

	#must call memcpy()

	# be careful when calling memcpy --> would probably use s registers or something

	# a0 = pointer to arrays of cars
	# a1 = number of cars in array
	# a2 = pointer to new car to insert
	# a3 = index at which to be inserted

	blt $a1, $0, failure_part_4 # length < 0
	blt $a3, $0, failure_part_4 # index < 0
	bgt $a3, $a1, failure_part_4 # index > length

	# s0 = index of cars (starting at last) 
	move $s0, $a1
	addi $s0, $s0, -1
	sll $s0, $s0, 4 # multiply by 16
	add $s0, $s0, $a0 # add base address

	# s1 = index to insert
	move $s1, $a3
	sll $s1, $s1, 4
	add $s1, $s1, $a0
	addi $s1, $s1, -16 # subtract 16, so that car at index gets moved too

	# s2 = pointer to new car to insert
	move $s2, $a2

	# need to preserve $ra
	addi $sp, $sp, -4
	sw $ra, ($sp)

	# [0,1,2,3,4]

	# insert at index 3
	# length = 5, start moving at index 4

	move_cars_part_4:
		beq $s1, $s0, insert_at_index_part_4

		move $t0, $s0 
		addi $t0, $t0, 16 # t0 = index to move current car to

		move $a0, $s0
		move $a1, $t0
		li $a2, 16
		jal memcpy

		addi $s0, $s0, -16
		j move_cars_part_4

	insert_at_index_part_4:
		move $a0, $s2
		addi $s1, $s1, 16
		move $a1, $s1
		li $a2, 16
		jal memcpy

	# get $ra back
	lw $ra, ($sp)
	addi $sp, $sp, 4

	success_part_4:
		li $v0, 0
		jr $ra
	failure_part_4:
		li $v0, -1
		jr $ra

### Part V ###
most_damaged:

	# a0 = array of car structs
	# a1 = array of repair structs
	# a2 = num elements in cars
	# a3 = num elements in repairs

	ble $a2, $0, error_case_part_5
	ble $a3, $0, error_case_part_5

	# go through cars

	# save through stack 
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $s1, 0($sp)

	li $s0, 0 # car index to return
	li $s1, 0 # cost to return
	
	move $t0, $a0
	li $t1, 0 # car loop counter
	loop_cars_part_5:
		bge $t1, $a2, done_part_5 # done looping through cars

		move $t2, $a1
		li $t3, 0 # repair loop counter
		li $t7, 0 # t7 = current car repair cost
		loop_repairs_part_5:
			bge $t3, $a3, continue_cars_part_5 # CONTINUE

			# check if pointers are the same
			lw $t4, ($t2) # t4 = address of car
			bne $t4, $t0, diff_car_part_5

			# same car pointer
			addi $t5, $t2, 8 # go to cost
			lhu $t6, ($t5) # load cost

			add $t7, $t7, $t6 # add to current car cost

			# go to next car
			diff_car_part_5:
				addi $t2, $t2, 12
				addi $t3, $t3, 1
				j loop_repairs_part_5
		
		continue_cars_part_5:
		# check if current car repair cost is higher or not
		ble $t7, $s1, not_max_part_5

		# current car cost is higher than the max
		move $s0, $t1
		move $s1, $t7

		not_max_part_5:
			addi $t0, $t0, 16 # go to next car
			addi $t1, $t1, 1
			j loop_cars_part_5

	done_part_5:
		move $v0, $s0
		move $v1, $s1

		# reset stack
		lw $s0, 4($sp)
		lw $s1, 0($sp)
		addi $sp, $sp, 8

		jr $ra

	error_case_part_5:
		li $v0, -1
		li $v1, -1
		jr $ra


### Part VI ###
sort:
	li $v0, -200
	li $v1, -200
	
	jr $ra


### Part VII ###
most_popular_feature:
	li $v0, -200
	li $v1, -200
	
	jr $ra
	

### Optional function: not required for the assignment ###
transliterate:
	li $v0, -200
	li $v1, -200
	
	jr $ra


### Optional function: not required for the assignment ###
char_at:
	li $v0, -200
	li $v1, -200

	jr $ra


### Optional function: not required for the assignment ###
index_of:
	li $v0, -200
	li $v1, -200
		
	jr $ra


### Part VIII ###
compute_check_digit:
	li $v0, -200
	li $v1, -200
	
	jr $ra	

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
