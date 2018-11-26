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
        ori $t8, $t8, 0x80
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

# returns -1 in v0 for error (same conditions as is_valid)

addi $sp, $sp, -16
sw $s0, 12($sp)
sw $s1, 8($sp)
sw $s2, 4($sp)
sw $ra, 0($sp)
#  preserve argument values and ra

move $s0, $a0
move $s1, $a1
move $s2, $a2

# arguments are already in their respective a registers for is_valid
jal is_valid_cell
bne $v0, $0, p3_error
# otherwise it is a valid index

lbu $t0, 1($s0) # t0 = map num cols

addi $s0, $s0, 2 # s0 now points to cell[0][0]

# elem size = 1
# index =  (row index) * (num cols) + (col index) + (base address)

mult $s1, $t0
mflo $t2 # t2 = row index * num cols
add $t2, $t2, $s2 # t2 = t2 + col index
add $t2, $t2, $s0 # add base address

lbu $v0, ($t2)
# returns v0 = byte at map_ptr.cells[row][col]
j p3_done

p3_error:
    li $v0, -1

p3_done:
    lw $ra, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    addi $sp, $sp, 16

    jr $ra


# Part IV
set_cell:
# a0 = address of Map struct
# a1 = row index
# a2 = col index
# a3 = byte to be written

# returns -1 if error (same as is_valid conditions)
addi $sp, $sp, -20
sw $s0, 16($sp)
sw $s1, 12($sp)
sw $s2, 8($sp)
sw $s3, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3

# arguments are already in their respective a registers for is_valid
jal is_valid_cell
bne $v0, $0, p4_error
# otherwise it is a valid index

lbu $t0, 1($s0) # t0 = map num cols

addi $s0, $s0, 2 # s0 now points to cell[0][0]

# elem size = 1
# index =  (row index) * (num cols) + (col index) + (base address)

mult $s1, $t0
mflo $t2 # t2 = row index * num cols
add $t2, $t2, $s2 # t2 = t2 + col index
add $t2, $t2, $s0 # add base address

sb $s3, ($t2) # store byte

li $v0, 0
j p4_done

p4_error:
    li $v0, -1

p4_done:
    lw $ra, 0($sp)
    lw $s3, 4($sp)
    lw $s2, 8($sp)
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    addi $sp, $sp, 20

    jr $ra


# Part V
reveal_area:
# a0 = address of Map struct
# a1 = row index (in center of 3 x 3 area to be revealed)
# a2 = col index (in center of 3 x 3 area to be revealed)

addi $sp, $sp, -24
sw $s0, 20($sp)
sw $s1, 16($sp)
sw $s2, 12($sp)
sw $s3, 8($sp)
sw $s4, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
addi $s1, $a1, 1 # s1 = row index limit 
addi $s2, $a2, 1 # s2 = col index limit (right corner of 9 x 9 grid)

addi $s3, $s1, -2 # s3 = row index of cell (start at left corner of 9 x 9 grid)
p5_loop_rows:
    bgt $s3, $s1, p5_done

    addi $s4, $s2, -2 # s4 = col index of cell (start at left side)
    p5_loop_cols:
        bgt $s4, $s2, p5_continue_row

        # if current row, col is valid
            # get the cell 
            # set the cell by setting bit 7 of the cell to 0

        # check if valid
        move $a0, $s0
        move $a1, $s3 # row to test
        move $a2, $s4 # col to test
        jal is_valid_cell
        bne $v0, $0, p5_not_valid
        #else it is valid

        # get the cell
        move $a0, $s0
        move $a1, $s3
        move $a2, $s4
        jal get_cell

        # set bit 7 of the cell to 0
        # 0111 1111
        andi $t0, $v0, 0x7F
        move $a0, $s0
        move $a1, $s3
        move $a2, $s4
        move $a3, $t0
        jal set_cell

        p5_not_valid:

        addi $s4, $s4, 1
        j p5_loop_cols

    p5_continue_row:

    addi $s3, $s3, 1
    j p5_loop_rows

p5_done:
    lw $ra, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    addi $sp, $sp, 24
    jr $ra

# Part VI
get_attack_target:

# a0 = Map struct address
# a1 = Player struct address
# a2 = char = {'U','D','L','R'}

addi $sp, $sp, -4
sw $ra, 0($sp)

beq $a2, 'U', p6_valid_char
beq $a2, 'D', p6_valid_char
beq $a2, 'L', p6_valid_char
beq $a2, 'R', p6_valid_char

j p6_error # not one of the valid characters

p6_valid_char:
    lbu $t0, 0($a1) # player row
    lbu $t1, 1($a1) # player col

    bne $a2, 'U', p6_not_U
    # otherwise check up direction
    # map pointer already in a0
    addi $a1, $t0, -1 # previous row
    move $a2, $t1
    jal get_cell
    j p6_target_cell_obtained

    p6_not_U:
    bne $a2, 'D', p6_not_D
    # otherwise check down direction
    # map pointer already in a0
    addi $a1, $t0, 1 # next row
    move $a2, $t1
    jal get_cell
    j p6_target_cell_obtained

    p6_not_D:
    bne $a2, 'L', p6_not_L
    # otherwise check left direction
    # map pointer already in a0
    move $a1, $t0 
    addi $a2, $t1, -1 # previous col
    jal get_cell
    j p6_target_cell_obtained

    p6_not_L:
    # otherwise check right direction
    # map pointer already in a0
    move $a1, $t0 
    addi $a2, $t1, 1 # next col
    jal get_cell

    p6_target_cell_obtained:
        # check if valid 
        beq $v0, -1, p6_error

        # ONLY FOR TESTING
        # andi $v0, $v0, 0x7F
        # UNCOMMENT TO TEST
        

        # check if 'm', 'B', or '/'
        beq $v0, 'm', p6_valid_target_cell
        beq $v0, 'B', p6_valid_target_cell
        beq $v0, '/', p6_valid_target_cell

        j p6_error

        p6_valid_target_cell:
            # v0 already contains the targeted cell
            j p6_done

p6_error:
    li $v0, -1

p6_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
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
