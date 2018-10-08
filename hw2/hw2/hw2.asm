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
	ble $a1, 0, index_of_car_error #length less <= to 0

	# start_index --> the index at which to start the search
	# $a2 = start_index
	blt $a2, 0, index_of_car_error #start index < 0
	bge $a2, $a1, index_of_car_error #start index >= length

	# year --> the year of manufacture
	# $a3 = year
	blt $a3, 1885, index_of_car_error #year < 1885

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

	traverse:
		bge $t0, $a1, index_of_car_error # not found car with given year
		# current index NOT greater than length:

		lhu $t2, ($t1)
		beq $t2, $a3, found_index

		addi $t1, $t1, 16 #add 16 bytes --> go to the next car's 
		addi $t0, $t0, 1
		j traverse
	
	found_index:
		# v0 --> the index of the located car
		move $v0, $t0
		jr $ra

	index_of_car_error:
		li $v0, -1
		jr $ra
	

### Part II ###
strcmp:
	li $v0, -200
	li $v1, -200

	jr $ra


### Part III ###
memcpy:
	li $v0, -200
	li $v1, -200

	jr $ra


### Part IV ###
insert_car:
	li $v0, -200
	li $v1, -200
	

	jr $ra
	

### Part V ###
most_damaged:
	li $v0, -200
	li $v1, -200
	
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
