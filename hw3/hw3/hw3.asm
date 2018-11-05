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

# Helper - Part I
# given the index, return the character
p1_helper:
    # a0 = valid index
    beq $a0, 0, p1_helper_A
    beq $a0, 1, p1_helper_D
    beq $a0, 2, p1_helper_F
    beq $a0, 3, p1_helper_G
    beq $a0, 4, p1_helper_V
    beq $a0, 5, p1_helper_X

    p1_helper_A:
        li $v0, 'A'
        j p1_helper_done
    p1_helper_D:
        li $v0, 'D'
        j p1_helper_done
    p1_helper_F:
        li $v0, 'F'
        j p1_helper_done
    p1_helper_G:
        li $v0, 'G'
        j p1_helper_done
    p1_helper_V:
        li $v0, 'V'
        j p1_helper_done
    p1_helper_X:
        li $v0, 'X'
        j p1_helper_done

    p1_helper_done:
        jr $ra


# Part I
get_adfgvx_coords:
# a0 = index1
# a1 = index2

bltz $a0, p1_error_case # index1 < 0
bgt $a0, 5, p1_error_case # index1 > 5
bltz $a1, p1_error_case # index2 < 0
bgt $a1, 5, p1_error_case # index2 > 5

addi $sp, $sp, -4
sw $ra, 0($sp)

jal p1_helper
move $t0, $v0
# v0 = the character in ADFGVX at index1
move $a0, $a1
jal p1_helper
move $v1, $v0
move $v0, $t0
# v1 = the character in ADFGVX at index2

lw $ra, 0($sp)
addi $sp, $sp, 4

j p1_done

p1_error_case:
    li $v0, -1
    li $v1, -1

p1_done:
    jr $ra

# Part II
search_adfgvx_grid:
# a0 = char array address
# a1 = character 2D index we want to find

# v0 = row index of the plain text character
# v1 = col index of the plain text character

move $t0, $a0
lbu $t1, ($a0)
p2_search_grid:
    beqz $t1, p2_error_case
    beq $t1, $a1, p2_found_char
    addi $a0, $a0, 1
    lbu $t1, ($a0)

j p2_search_grid

p2_found_char:
    sub $t1, $a0, $t0
    # t1 = index in the row major order array
    li $t0, 6 # 6x6 array
    div $t1, $t0 # index / 6
    mflo $v0
    mfhi $v1
    j p2_done

p2_error_case:
    li $v0, -1
    li $v1, -1

p2_done:
    jr $ra

# Part III
map_plaintext:
li $v0, -200
li $v1, -200

jr $ra

# Part IV
swap_matrix_columns:
li $v0, -200
li $v1, -200

jr $ra

# Part V
key_sort_matrix:
li $v0, -200
li $v1, -200

jr $ra

# Part IV
transpose:
li $v0, -200
li $v1, -200

jr $ra

# Part VII
encrypt:
li $v0, -200
li $v1, -200

jr $ra

# Part VIII
lookup_char:
li $v0, -200
li $v1, -200

jr $ra

# Part IX
string_sort:
li $v0, -200
li $v1, -200

jr $ra

# Part X
decrypt:
li $v0, -200
li $v1, -200

jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
