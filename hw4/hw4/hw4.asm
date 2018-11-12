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

# moved argument registers to s registers to preserve
# just in case syscall modifies the a registers
# essentially, I treated the syscalls as functions

addi $sp, $sp, -20
sw $s0, 16($sp)
sw $s1, 12($sp)
sw $s2, 8($sp)
sw $s3, 4($sp) # s3 = used to hold file descriptor
sw $s4, 0($sp) # s4 = temp variable (preserved between syscalls)

move $s0, $a0
move $s1, $a1
move $s2, $a2

li $v0, 13 # open file
# file name already in a0
li $a1, 0 # read only
syscall
move $s3, $v0 
bltz $s3, p1_error # negative if error

# keep reading a byte and 'converting' --> until new line
li $s4, 0
p1_read_map_rows:
    li $v0, 14 # read file
    move $a0, $s3
    move $a1, $s1
    li $a2, 1
    syscall
    bltz $v0, p1_error # negative if error

    lbu $t0, ($s1)
    beq $t0, 10, p1_map_rows_done # ASCII '\n'
    # otherwise it is a valid ASCII numerical character

    li $t1, 10
    mult $s4, $t1 # multiply numbers in register by 10
    mflo $s4

    addi $t0, $t0, -48 # - ASCII '0'
    add $s4, $s4, $t0
    j p1_read_map_rows

p1_map_rows_done:
    sb $s4, ($s1) # store number of rows in MAP struct
    addi $s1, $s1, 1 # move forward 1 byte in a1

li $s0, 0 # override s0 to 0 - don't need filename anymore
p1_read_map_cols:
    li $v0, 14
    move $a0, $s3
    move $a1, $s1
    li $a2, 1
    syscall
    bltz $v0, p1_error # negative if error

    lbu $t0, ($s1)
    beq $t0, 10, p1_map_cols_done # ASCII '\n'
    # otherwise it is a valid ASCII numerical character

    li $t1, 10
    mult $s0, $t1 # multiply numbers in register by 10
    mflo $s0

    addi $t0, $t0, -48 # - ASCII '0'
    add $s0, $s0, $t0
    j p1_read_map_cols

p1_map_cols_done:
    sb $s0, ($s1)
    addi $s1, $s1, 1 # move forward 1 byte in a1

# s0 = num_rows * num_cols
mult $s0, $s4
mflo $s0 
p1_read_map:

li $v0, 0
j p1_done

p1_error:
    li $v0, -1

p1_done:
    li $v0, 16 # close file
    move $a0, $s3
    syscall

    lw $s4, 0($sp)
    lw $s3, 4($sp)
    lw $s2, 8($sp)
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    addi $sp, $sp, 20
# v0 = 0 if successful, -1 otherwise
jr $ra


# Part II
is_valid_cell:
li $v0, -200
li $v1, -200
jr $ra


# Part III
get_cell:
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
