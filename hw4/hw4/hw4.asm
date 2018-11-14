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

# Part I
init_game:
# a0 = map_filename - string
# a1 = map_ptr = pointer to Map struct
# a2 = player_ptr = pointer to Player struct

move $t0, $a0 # t0 = map file name
move $t1, $a1 # t1 = map pointer
move $t2, $a2 # t2 = player pointer
# t3 = will hold file descriptor
# t4 = will hold num rows
# t5 = will hold num cols
# t6 = temp variable
# t7 = temp variable
# t8 = temp variable

# since MARS is a simulator, syscalls won't affect t registers

li $v0, 13 # open file
# file name already in a0
li $a1, 0 # read only
syscall
move $t3, $v0 # t3 = file descriptor
bltz $t3, p1_error # negative if error

# keep reading a byte and 'converting' --> until new line
li $t4, 0 # t4 = num rows

# read file set up

p1_read_map_rows:
    li $v0, 14
    move $a0, $t3
    move $a1, $t1
    li $a2, 1
    syscall
    bltz $v0, p1_error # negative if error

    lbu $t6, ($t1)
    beq $t6, 10, p1_map_rows_done # ASCII '\n'
    # otherwise it is a valid ASCII numerical character

    li $t7, 10
    mult $t4, $t7 # multiply numbers in register by 10
    mflo $t4

    addi $t6, $t6, -48 # - ASCII '0' - turn read byte into a digit
    add $t4, $t4, $t6 # add digit to current number of rows
    j p1_read_map_rows

p1_map_rows_done:
    sb $t4, ($t1) # store number of rows in MAP struct
    addi $t1, $t1, 1 # move forward 1 byte in a1

li $t5, 0 # t5 = num cols
p1_read_map_cols:
    li $v0, 14
    move $a0, $t3
    move $a1, $t1
    li $a2, 1
    syscall
    bltz $v0, p1_error # negative if error

    lbu $t6, ($t1)
    beq $t6, 10, p1_map_cols_done # ASCII '\n'
    # otherwise it is a valid ASCII numerical character

    li $t7, 10
    mult $t5, $t7 # multiply numbers in register by 10
    mflo $t5

    addi $t6, $t6, -48 # - ASCII '0'
    add $t5, $t5, $t6
    j p1_read_map_cols

p1_map_cols_done:
    sb $t5, ($t1)
    addi $t1, $t1, 1 # move forward 1 byte in a1

#t6 = num_rows * num_cols
mult $t4, $t5
mflo $t6  # t6 = num of bytes to read for map
li $t7, 0 # t7 = counter
p1_read_map:
    bge $t7, $t6, p1_read_player

    li $v0, 14
    move $a0, $t3
    move $a1, $t1
    li $a2, 1
    syscall
    bltz $v0, p1_error # negative if error

    lbu $t8, ($t1)
    beq $t8, 10, p1_read_map # ASCII newline - don't store
    bne $t8, 64, p1_not_player# ASCII '@'

    # read player position information
    # (counter) mod (num_cols) = column index
    # (counter) / (num_cols) = row index

    div $t7, $t5 
    mflo $t5 # t6 = floor(counter / cols) = row 
    mfhi $t4 # t4 = counter mod cols = col

    sb $t5, ($t2) # store row
    addi $t2, $t2, 1 # go to next byte
    sb $t4, ($t2) # store col
    addi $t2, $t2, 1

    p1_not_player:
        # set hidden flag - every character initially hidden
        # 1000 0000 = 0x80
        xori $t8, $t8, 0x80
        sb $t8, ($t1)

        addi $t1, $t1, 1
        addi $t7, $t7, 1 # increase counter

    j p1_read_map

li $t6, 0
p1_read_player:
    li $v0, 14
    move $a0, $t3
    move $a1, $t2 # input buffer = player struct byte 2
    li $a2, 1
    syscall

    lbu $t7, ($t2)
    beqz $t7, p1_success # null terminator
    beq $t7, 10, p1_success # ASCII '\n'
    # otherwise it is a valid ASCII numerical character

    li $t8, 10
    mult $t6, $t8 # multiply numbers in register by 10
    mflo $t6

    addi $t7, $t7, -48 # - ASCII '0' - turn read byte into a digit
    add $t6, $t6, $t7 # add digit to current number of rows

    j p1_read_player

p1_success:
    addi $t2, $t2, 1 # go to next player byte
    # store 0 = num coins
    sb $0, ($t2)
    li $v0, 0
    j p1_done

p1_error:
    li $v0, -1

p1_done:
    li $v0, 16 # close file
    move $a0, $t3
    syscall

# v0 = 0 if successful, -1 otherwise
jr $ra


# Part II
is_valid_cell:
# a0 = starting address of a Map struct
# a1 = row (0 based row index of the desired byte)
# a2 = col (0 based col index of the desired byte)

# returns v0 = 0 if (row, col) a valid index pair, or -1 if not

lbu $t0, ($a0) # t0 = num rows of map
addi $a0, $a0, 1 # t1 = num cols of map
lbu $t1, ($a0)

bltz $a1, p2_error # row < 0
bge $a1, $t0, p2_error # row >= num rows
bltz $a2, p2_error # col < 0
bge $a2, $t1, p2_error # col >= num cols

li $v0, 0
j p2_done

p2_error:
    li $v0, -1

p2_done:
    jr $ra


# Part III
get_cell:
# a0 = starting address of a Map struct
# a1 = row (0 based row index of the desired byte)
# a2 = col (0 based col index of the desired byte)

# returns -1 in v0 for error
# row < 0
# row >= map_ptr.num_rows
# col < 0
# col >= map_ptr.num_cols

# returns v0 = byte at map_ptr.cells[row][col]
li $v0, -200
li $v1, -200
jr $ra


# Part IV
set_cell:
li $v0, -200
li $v1, -200
jr $ra


# Part V
reveal_area:
li $v0, -200
li $v1, -200
jr $ra

# Part VI
get_attack_target:
li $v0, -200
li $v1, -200
jr $ra


# Part VII
monster_attacks:
li $v0, -200
li $v1, -200
jr $ra


# Part VIII
player_move:
li $v0, -200
li $v1, -200
jr $ra


# Part IX
complete_attack:
li $v0, -200
li $v1, -200
jr $ra


# Part X
player_turn:
li $v0, -200
li $v1, -200
jr $ra


# Part XI
flood_fill_reveal:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
