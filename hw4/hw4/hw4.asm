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
    bge $t7, $t6, p1_read_player_start

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

p1_read_player_start:
li $t6, 0
# may not have read new line
li $v0, 14
move $a0, $t3
move $a1, $t2
li $a2, 1
syscall

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
    sb $t6, ($t2) # store player health
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
complete_attack:
# a0 = address of Map struct
# a1 = address of Player struct
# a2 = target cell row
# a3 = target cell col

addi $sp, $sp, -20
sw $s3, 16($sp)
sw $s2, 12($sp)
sw $s1, 8($sp)
sw $s0, 4($sp)
sw $ra, 0($sp)

# externally determined if targeted cell can be validly attacked

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3

# get cell
# map already in a0
move $a1, $s2
move $a2, $s3
jal get_cell

# ONLY FOR TESTING
# andi $v0, $v0, 0x7F
# UNCOMMENT TO TEST

beq $v0, '/', p7_door

lb $t0, 2($s1) # load player's current health
beq $v0, 'm', p7_minion

p7_boss:
    li $t1, '*'
    addi $t0, $t0, -2 # 2 points of damage
    sb $t0, 2($s1) # store health
    j p7_continue

p7_minion:
    li $t1, '$'
    addi $t0, $t0, -1 # 1 point of damage
    sb $t0, 2($s1) # store health
    j p7_continue

p7_door:
    li $t1, '.'

p7_continue:
    # t1 = replacement character
    move $a0, $s0
    move $a1, $s2
    move $a2, $s3
    move $a3, $t1
    jal set_cell

    # check if player is dead
    lb $t0, 2($s1)
    bgt $t0, $0, p7_done # if health greater than 0
    # player is dead
    move $a0, $s0
    lbu $a1, 0($s1)
    lbu $a2, 1($s1)
    li $a3, 'X'
    jal set_cell

p7_done:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20

    jr $ra

# Part VIII
monster_attacks:
# a0 = address of Map
# a1 = address of Player

addi $sp, $sp, -20
sw $s0, 16($sp)
sw $s1, 12($sp)
sw $s2, 8($sp)
sw $s3, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
lb $s1, 0($a1) # s1 = player row
lb $s2, 1($a1) # s2 = player col
li $s3, 0 # s3 = damage 

# check each direction

# (r - 1, c)
p8_check_up:
    move $a0, $s0
    addi $a1, $s1, -1
    move $a2, $s2
    jal get_cell
    # ONLY FOR TESTING
    # andi $v0, $v0, 0x7F
    # UNCOMMENT TO TEST

    beq $v0, 'm', p8_up_minion
    beq $v0, 'B', p8_up_boss
    j p8_check_down

    p8_up_boss:
        addi $s3, $s3, 1
    p8_up_minion:
        addi $s3, $s3, 1

# (r + 1, c)
p8_check_down:
    move $a0, $s0
    addi $a1, $s1, 1
    move $a2, $s2
    jal get_cell
    # ONLY FOR TESTING
    # andi $v0, $v0, 0x7F
    # UNCOMMENT TO TEST

    beq $v0, 'm', p8_down_minion
    beq $v0, 'B', p8_down_boss
    j p8_check_left

    p8_down_boss:
        addi $s3, $s3, 1
    p8_down_minion:
        addi $s3, $s3, 1

# (r, c - 1)
p8_check_left:
    move $a0, $s0
    move $a1, $s1
    addi $a2, $s2, -1
    jal get_cell
    # ONLY FOR TESTING
    # andi $v0, $v0, 0x7F
    # UNCOMMENT TO TEST

    beq $v0, 'm', p8_left_minion
    beq $v0, 'B', p8_left_boss
    j p8_check_right

    p8_left_boss:
        addi $s3, $s3, 1
    p8_left_minion:
        addi $s3, $s3, 1

# (r, c + 1)
p8_check_right:
    move $a0, $s0
    move $a1, $s1
    addi $a2, $s2, 1
    jal get_cell
    # ONLY FOR TESTING
    # andi $v0, $v0, 0x7F
    # UNCOMMENT TO TEST

    beq $v0, 'm', p8_right_minion
    beq $v0, 'B', p8_right_boss
    j p8_continue

    p8_right_boss:
        addi $s3, $s3, 1
    p8_right_minion:
        addi $s3, $s3, 1

p8_continue:
move $v0, $s3 # return damage

lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s2, 8($sp)
lw $s1, 12($sp)
lw $s0, 16($sp)
addi $sp, $sp, 20

jr $ra

# Part IX
player_move:
# a0 = address of Map struct
# a1 = address of Player struct
# a2 = target cell row
# a3 = target cell col

# externally deremined if the player can attempt to move to the target cell
addi $sp, $sp, -24
sw $s0, 20($sp)
sw $s1, 16($sp)
sw $s2, 12($sp)
sw $s3, 8($sp)
sw $s4, 4($sp) # s4 = hold target cell char
sw $ra, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3

# calls monster_attacks
# a0 , a1 already holds Map and Player struct addresses
jal monster_attacks

# substract from health
lb $t0, 2($s1) # load current player health
sub $t0, $t0, $v0 # health = current health - monster attack
sb $t0, 2($s1) # store player health

bgt $t0, $0, p9_check_cell # still alive
# Nearby monsters killed the player
move $a0, $s0
lbu $a1, 0($s1)
lbu $a2, 1($s1)
li $a3, 'X'
jal set_cell

li $v0, 0
j p9_done

p9_check_cell:
move $a0, $s0
move $a1, $s2
move $a2, $s3
jal get_cell
# ONLY FOR TESTING
# andi $v0, $v0, 0x7F
# UNCOMMENT TO TEST
move $s4, $v0 # s4 = target cell character

# replace player's position with '.'
move $a0, $s0
lbu $a1, 0($s1)
lbu $a2, 1($s1)
li $a3, '.'
jal set_cell

# replace target's position with '@'
move $a0, $s0
move $a1, $s2
move $a2, $s3
li $a3, '@'
jal set_cell

# update Player struct's position
sb $s2, 0($s1)
sb $s3, 1($s1)

beq $s4, '>', p9_door
beq $s4, '.', p9_floor
# otherwise it is a coin or gem

lbu $t0, 3($s1) # load coin count
beq $s4, '$', p9_coin
p9_gem:
    addi $t0, $t0, 4 # add 4 (will add 1 below --> 5)

p9_coin:
    addi $t0, $t0, 1 # add 1
    sb $t0, 3($s1)
    li $v0, 0
    j p9_done

p9_floor:
    li $v0, 0
    j p9_done

p9_door:
    li $v0, -1

p9_done:
    lw $ra, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    addi $sp, $sp, 24
    jr $ra


# Part X
player_turn:
# a0 = Map struct address
# a1 = Player struct address
# a2 = char

addi $sp, $sp, -24
sw $s0, 20($sp)
sw $s1, 16($sp)
sw $s2, 12($sp)
sw $s3, 8($sp)
sw $s4, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2

# load current player position
lbu $s3, 0($s1) # s3 = player row
lbu $s4, 1($s1) # s4 = player col

beq $s2, 'U', p10_up
beq $s2, 'D', p10_down
beq $s2, 'L', p10_left
beq $s2, 'R', p10_right
j p10_character_error # not one of the valid characters

p10_up:
    addi $s3, $s3, -1
    j p10_continue

p10_down:
    addi $s3, $s3, 1
    j p10_continue

p10_left:
    addi $s4, $s4, -1
    j p10_continue

p10_right:
    addi $s4, $s4, 1

p10_continue:
    # check if valid
    # get cell
    move $a0, $s0
    move $a1, $s3
    move $a2, $s4
    jal get_cell
    beq $v0, -1, p10_zero_error
    # otherwise valid
    beq $v0, '#', p10_zero_error
    # otherwise target cell is moveable/attackable

    # check if attackable
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal get_attack_target
    beq $v0, -1, p10_not_attackable
    # otherwise target cell is attackable

    # complete attack
    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    move $a3, $s4
    jal complete_attack
    j p10_zero_error

p10_not_attackable:
    # move player
    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    move $a3, $s4
    jal player_move
    # return move player's return value
    j p10_done

p10_zero_error:
    li $v0, 0
    j p10_done

p10_character_error:
    li $v0, -1

p10_done:
    lw $ra, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    addi $sp, $sp, 24
    jr $ra

p11_helper:
    # a0 = byte address
    # a1 = modulo
    # returns byte or 0
   
    lbu $t0, 0($a0) # load byte 
    beq $a1, 1, p11_1
    beq $a1, 2, p11_2
    beq $a1, 3, p11_3
    beq $a1, 4, p11_4
    beq $a1, 5, p11_5
    beq $a1, 6, p11_6
    beq $a1, 7, p11_7

    # otherwise the modulo is 0
    p11_0:
        andi $t1, $t0, 0x80 
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x80
        j p11_helper_done
    p11_1:
        andi $t1, $t0, 0x40 
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x40
        j p11_helper_done
    p11_2:
        andi $t1, $t0, 0x20 
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x20
        j p11_helper_done
    p11_3:
        andi $t1, $t0, 0x10 
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x10
        j p11_helper_done
    p11_4:
        andi $t1, $t0, 0x08
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x08
        j p11_helper_done
    p11_5:
        andi $t1, $t0, 0x04
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x04
        j p11_helper_done
    p11_6:
        andi $t1, $t0, 0x02
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x02
        j p11_helper_done
    p11_7:
        andi $t1, $t0, 0x01
        bne $t1, $0, p11_helper_visited_already
        ori $v0, $t0, 0x01
        j p11_helper_done

    p11_helper_visited_already:
        li $v0, 0

    p11_helper_done:
        jr $ra

# Part XI
flood_fill_reveal:
# a0 = Map address
# a1 = row where the flood begins
# a2 = col where the flood begins
# a3 = 2D array address 

addi $sp, $sp, -32
sw $s0, 28($sp)
sw $s1, 24($sp)
sw $s2, 20($sp)
sw $s3, 16($sp)
sw $s4, 12($sp)
sw $s5, 8($sp)
sw $fp, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3

# get cell
# arguments are already in their respective registers
jal get_cell
beq $v0, -1, p11_error

move $fp, $sp # fp = sp
addi $sp, $sp, -8 # to push in 2 bytes
sw $s1, 4($sp) # sp.push(row)
sw $s2, 0($sp) # sp.push(col)

# offsets = [(-1,0), (1,0), (0,-1), (0,1)]
p11_while_loop:
    beq $sp, $fp, p11_success
    lbu $s5, 0($sp) # s5 = col = sp.pop()
    lbu $s4, 4($sp) # s4 = row = sp.pop()
    addi $sp, $sp, 8

    # make the cell visible in the world map
    
    # get the cell
    move $a0, $s0
    move $a1, $s4
    move $a2, $s5
    jal get_cell

    # set bit 7 of the cell to 0
    # 0111 1111
    andi $t0, $v0, 0x7F
    move $a0, $s0
    move $a1, $s4
    move $a2, $s5
    move $a3, $t0
    jal set_cell

    # for each pair (i,j) of values in offsets:
    # get cell at (row + i, col + j) 
    # can overwrite s1, s2
    lbu $s2, 1($s0) # s2 = num cols
    # index = (num_cols * row) + col 

    # (-1,0)
    p11_first_pair:
        move $a0, $s0
        addi $s4, $s4, -1
        move $a1, $s4
        move $a2, $s5
        jal get_cell
        # check if empty floor
        andi $v0, $v0, 0x7F # account for both hidden or revealed
        bne $v0, '.', p11_second_pair 
        # is an empty floor
        mult $s4, $s2 # row * num_cols
        mflo $t0
        add $t0, $t0, $s5 # add col index

        li $t4, 8
        div $t0, $t4 # divide index by 8 to get byte number
        mflo $t1 # t1 = floor($t0 / 4) --> byte number
        mfhi $a1 # t2 = t0 mod 4
        add $s1, $t1, $s3 # add base address to byte number
        move $a0, $s1 
        jal p11_helper
        # v0 has byte or 0 (already visited)
        beqz $v0, p11_second_pair
        # not visited yet
        # store the byte
        sb $v0, 0($s1)
        addi $sp, $sp, -8
        sw $s4, 4($sp) # sp.push(row)
        sw $s5, 0($sp) # sp.push(col)

    # (1,0) 
    p11_second_pair:
        move $a0, $s0
        addi $s4, $s4, 2 # -1 + 2 = 1
        move $a1, $s4
        move $a2, $s5
        jal get_cell
        # check if empty floor
        andi $v0, $v0, 0x7F # account for both hidden or revealed
        bne $v0, '.', p11_third_pair 
        # is an empty floor
        mult $s4, $s2 # row * num_cols
        mflo $t0
        add $t0, $t0, $s5 # add col index

        li $t4, 8
        div $t0, $t4 # divide index by 8 to get byte number
        mflo $t1 # t1 = floor($t0 / 4) --> byte number
        mfhi $a1 # t2 = t0 mod 4
        add $s1, $t1, $s3 # add base address to byte number
        move $a0, $s1 
        jal p11_helper
        # v0 has byte or 0 (already visited)
        beqz $v0, p11_third_pair
        # not visited yet
        # store the byte
        sb $v0, 0($s1)
        addi $sp, $sp, -8
        sw $s4, 4($sp) # sp.push(row)
        sw $s5, 0($sp) # sp.push(col)

    # (0,-1)
    p11_third_pair:
        move $a0, $s0
        addi $s4, $s4, -1 # 1 - 1 = 0
        move $a1, $s4
        addi $s5, $s5, -1 
        move $a2, $s5
        jal get_cell
        # check if empty floor
        andi $v0, $v0, 0x7F # account for both hidden or revealed
        bne $v0, '.', p11_fourth_pair
        # is an empty floor
        mult $s4, $s2 # row * num_cols
        mflo $t0
        add $t0, $t0, $s5 # add col index

        li $t4, 8
        div $t0, $t4 # divide index by 8 to get byte number
        mflo $t1 # t1 = floor($t0 / 4) --> byte number
        mfhi $a1 # t2 = t0 mod 4
        add $s1, $t1, $s3 # add base address to byte number
        move $a0, $s1 
        jal p11_helper
        # v0 has byte or 0 (already visited)
        beqz $v0, p11_fourth_pair
        # not visited yet
        # store the byte
        sb $v0, 0($s1)
        addi $sp, $sp, -8
        sw $s4, 4($sp) # sp.push(row)
        sw $s5, 0($sp) # sp.push(col)

    # (0,1)
    p11_fourth_pair:
        move $a0, $s0
        move $a1, $s4
        addi $s5, $s5, 2 # -1 + 2 = 1
        move $a2, $s5
        jal get_cell
        # check if empty floor
        andi $v0, $v0, 0x7F # account for both hidden or revealed
        bne $v0, '.', p11_while_loop
        # is an empty floor
        mult $s4, $s2 # row * num_cols
        mflo $t0
        add $t0, $t0, $s5 # add col index

        li $t4, 8
        div $t0, $t4 # divide index by 8 to get byte number
        mflo $t1 # t1 = floor($t0 / 4) --> byte number
        mfhi $a1 # t2 = t0 mod 4
        add $s1, $t1, $s3 # add base address to byte number
        move $a0, $s1 
        jal p11_helper
        # v0 has byte or 0 (already visited)
        beqz $v0, p11_while_loop
        # not visited yet
        # store the byte
        sb $v0, 0($s1)
        addi $sp, $sp, -8
        sw $s4, 4($sp) # sp.push(row)
        sw $s5, 0($sp) # sp.push(col)

    j p11_while_loop

p11_success:
    li $v0, 0
    j p11_done

p11_error:
    li $v0, -1

p11_done:
    lw $ra, 0($sp)
    lw $fp, 4($sp)
    lw $s5, 8($sp)
    lw $s4, 12($sp)
    lw $s3, 16($sp)
    lw $s2, 20($sp)
    lw $s1, 24($sp)
    lw $s0, 28($sp)
    addi $sp, $sp, 32
    jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
