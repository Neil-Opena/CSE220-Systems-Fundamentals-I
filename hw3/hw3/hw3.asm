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

# Helper - Part V
# swap indices in an array
p5_helper:
    # a0 = address of array
    # a1 = index 1
    # a2 = index 2
    # a3 = elem size

    mult $a1, $a3 # index1 * elem_size
    mflo $t0
    mult $a2, $a3 # index2 * elem_size
    mflo $t1
    add $t0, $t0, $a0 # index1 + address
    add $t1, $t1, $a0 # index2 + address

    bne $a3, 1, p5_helper_word
    # elem_size == 1
    lbu $t2, ($t0)
    lbu $t3, ($t1)
    sb $t2, ($t1)
    sb $t3, ($t0)
    jr $ra

    p5_helper_word:
    # elem_size == 4
    lw $t2, ($t0)
    lw $t3, ($t1)
    sw $t2, ($t1)
    sw $t3, ($t0)
    jr $ra

# Helper - Part VIII
# checks if the character given is any of the following: ADFGVX
# if so, returns corresponding index, else, returns -1
p8_helper:
    # a0 = letter
    beq $a0, 'A', p8_helper_A
    beq $a0, 'D', p8_helper_D
    beq $a0, 'F', p8_helper_F
    beq $a0, 'G', p8_helper_G
    beq $a0, 'V', p8_helper_V
    beq $a0, 'X', p8_helper_X
    j p8_helper_error

    p8_helper_A:
        li $v0, 0
        j p8_helper_done
    p8_helper_D:
        li $v0, 1
        j p8_helper_done
    p8_helper_F:
        li $v0, 2
        j p8_helper_done
    p8_helper_G:
        li $v0, 3
        j p8_helper_done
    p8_helper_V:
        li $v0, 4
        j p8_helper_done
    p8_helper_X:
        li $v0, 5
        j p8_helper_done

    p8_helper_error:
        li $v0, -1
    p8_helper_done:
        jr $ra

# Helper - Part X
# gets index of character in specified string
p10_helper:
    # a0 = string 
    # a1 = character
    li $t0, 0
    p10_helper_loop:
        lbu $t1, ($a0)
        beq $t1, $a1, p10_helper_done
        addi $a0, $a0, 1
        addi $t0, $t0, 1
        j p10_helper_loop

    p10_helper_done:
        move $v0, $t0
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
# a0 = adfgvx char array address
# a1 = null terminated message to convert to ADFGVX coordinates
# a2 = mapping char array address

# for each character of the string
    # look for row and col
    # get adfgvx letters corresponding to row and col
# put letters into mapping

# need to save:a0,a1,a2,ra
addi $sp, $sp, -16
sw $s0, 12($sp)
sw $s1, 8($sp)
sw $s2, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2

lbu $t0, ($s1)
p3_traverse_string:
    beqz  $t0, p3_done

    # t0 = current string char
    move $a0, $s0
    move $a1, $t0
    jal search_adfgvx_grid

    move $a0, $v0 
    move $a1, $v1
    jal get_adfgvx_coords

    sb $v0, ($s2)
    addi $s2, $s2, 1
    sb $v1, ($s2)
    addi $s2, $s2, 1

    addi $s1, $s1, 1
    lbu $t0, ($s1)
    j  p3_traverse_string

p3_done:
    lw $ra, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    addi $sp, $sp, 16

    jr $ra

# Part IV
swap_matrix_columns:
# a0 = matrix address
# a1 = number of rows
# a2 = number of cols
# a3 = index of first column to swap
# 0($sp) = index of second column to swap

ble $a1, 0, p4_error_case # num_rows <= 0
ble $a2, 0, p4_error_case # num_cols <= 0
bltz $a3, p4_error_case
bge $a3, $a2, p4_error_case

lb $t0, 0($sp)
bltz $t0, p4_error_case
bge $t0, $a2, p4_error_case

li $t1, 0 # t1 = row
add $a3, $a3, $a0 # col1 += address
add $t0, $t0, $a0 # col2 += address
p4_traverse_rows:
    bge $t1, $a1, p4_success_case
    # swap(col1, col2)
    lbu $t2, ($a3)
    lbu $t3, ($t0)
    sb $t2, ($t0)
    sb $t3, ($a3)

    add $a3, $a3, $a2 # col1 += num cols
    add $t0, $t0, $a2 # col2 += num cols

    addi $t1, $t1, 1
    j p4_traverse_rows

p4_success_case:
    li $v0, 0
    jr $ra

p4_error_case:
    li $v0, -1

p4_done:
    jr $ra

# Part V
key_sort_matrix:
# a0 = matrix address
# a1 = num rows
# a2 = num cols
# a3 = address of array of items being sorted
lbu $t0, 0($sp)
# t0 = elem_size (1 or 4)

addi $sp, $sp, -36
sw $s0, 32($sp)
sw $s1, 28($sp)
sw $s2, 24($sp)
sw $s3, 20($sp)
sw $s4, 16($sp)
sw $s5, 12($sp)
sw $s6, 8($sp)
sw $s7, 4($sp)
sw $ra, 0($sp)

move $s0, $a0 # s0 = matrix address
move $s1, $a1 # s1 = num rows
move $s2, $a2 # s2 = num cols
move $s3, $a3 # s3 = array address
move $s4, $t0 # s4 = elem size
# s5 = i
# s6 = j
li $s5, 0 # i = 0
p5_traverse_i:
    bge $s5, $s2, p5_done

    addi $s7, $s2, -1 #s7 = (n - 1)
    sub $s7, $s7, $s5 # s7 = (n - 1) - i
    li $s6, 0
    p5_traverse_j:
        bge $s6, $s7, p5_done_j

        mult $s6, $s4 # multiply j by elem_size
        mflo $t0 # t0 = j * elem_size
        add $t1, $t0, $s4 # t1 = (j * elem_size) + elem_size = (j + 1) * elem_size
        add $t0, $t0, $s3 # add address to modified j
        add $t1, $t1, $s3 # add address to modified j + 1

        bne $s4, 1, p5_load_word  
        # elem size == 1
        lbu $t2, ($t0)
        lbu $t3, ($t1)
        j p5_check_swap

        p5_load_word: 
        # elem size == 4
        lw $t2, ($t0)
        lw $t3, ($t1)

        p5_check_swap:
        ble $t2, $t3, p5_continue_j # if(A[j] <= A[j + 1])
        # (A[j] > A[j + 1])
        move $a0, $s3 # array address
        move $a1, $s6 # j
        addi $t5, $s6, 1 # t5 = j + 1
        move $a2, $t5
        move $a3, $s4
        jal p5_helper # swap key array

        move $a0, $s0
        move $a1, $s1
        move $a2, $s2
        move $a3, $s6
        addi $sp, $sp, -4
        addi $t4, $s6, 1 # j + 1 index
        sw $t4, 0($sp)
        jal swap_matrix_columns
        addi $sp, $sp, 4

        p5_continue_j:

            addi $s6, $s6, 1
            j p5_traverse_j

    p5_done_j:
        addi $s5, $s5, 1 # add 1 to the index
        j p5_traverse_i

# array length == num cols


p5_done:
    lw $ra, 0($sp)
    lw $s7, 4($sp)
    lw $s6, 8($sp)
    lw $s5, 12($sp)
    lw $s4, 16($sp)
    lw $s3, 20($sp)
    lw $s2, 24($sp)
    lw $s1, 28($sp)
    lw $s0, 32($sp)
    addi $sp, $sp, 36
    jr $ra

# Part VI
transpose:
# a0 = src matrix address
# a1 = dest matrix address
# a2 = src matrix num rows
# a3 = src matrix num cols

ble $a2, 0, p6_error_case # rows <= 0
ble $a3, 0, p6_error_case # cols <= 0

li $t0, 0 # j
p6_traverse_cols:
    bge $t0, $a3, p6_success_case  # col >= num cols

    li $t1, 0 # i
    p6_traverse_rows:
        bge $t1, $a2, p6_continue_col

        # traverse in col major order
        # src[i][j] = i * num_cols + j
        mult $t1, $a3
        mflo $t2 # t2 = i * num_cols
        add $t2, $t2, $t0 # t2 += j
        add $t2, $t2, $a0 # add base address
        lbu $t3, ($t2)

        sb $t3, ($a1)

        addi $t1, $t1, 1
        addi $a1, $a1, 1 # go to next dest matrix address
        j p6_traverse_rows

    p6_continue_col:
        addi $t0, $t0, 1
        j p6_traverse_cols

p6_success_case:
    li $v0, 0
    j p6_done
p6_error_case:
    li $v0, -1
p6_done:
    jr $ra

# Part VII
encrypt:
# a0 = adfgvx grid address
# a1 = plaintext string
# a2 - keyword string
# a3 - buffer for encrypted string

addi $sp, $sp, -32
sw $s0, 28($sp)
sw $s1, 24($sp)
sw $s2, 20($sp)
sw $s3, 16($sp)
sw $s4, 12($sp)
sw $s5, 8($sp)
sw $s6, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3
# used s4 to hold count of heap
# used s5 t0 hold address of heap
# used s6 to hoid keyword length

# get length of string
li $t0, 0 # counter for plaintext length
move $t1, $s1 # string address 
p7_loop_plaintext:
    lbu $t2, ($t1)
    beqz $t2, p7_start_loop_keyword
    addi $t0, $t0, 1
    addi $t1, $t1, 1 # go to next character
    j p7_loop_plaintext

p7_start_loop_keyword:
    li $t3, 0 # counter for keyword length
    move $t1, $s2 # string address
p7_loop_keyword:
    lbu $t2, ($t1)
    beqz $t2, p7_sbrk
    addi $t3, $t3, 1
    addi $t1, $t1, 1 # go to next character
    j p7_loop_keyword

# t0 = length of plaintext
# s6 = length of keyword
p7_sbrk:    
    move $s6, $t3
    # 2* plaintext length
    sll $t0, $t0, 0x1 
    # (2 * plaintext length) / t1
    div $t0, $s6
    mfhi $t2 # t0 mod s6
    mflo $t3 # t0 / s6
    beqz $t2, p7_no_remainder
    addi $t3, $t3, 1

        p7_no_remainder:
        mult $t3, $s6
        mflo $s4
        move $a0, $s4
        li $v0, 9
        syscall
        
move $t0, $v0 # t0 = heap address will be modified
move $s5, $v0 # s5 = heap address
li $t1, 0 # counter
li $t2, '*'
p7_fill_asterisks:
    bge $t1, $s4, p7_map_plaintext
    sb $t2, ($t0)

    addi $t1, $t1, 1
    addi $t0, $t0, 1
    j p7_fill_asterisks

p7_map_plaintext:
    move $a0, $s0
    move $a1, $s1
    move $a2, $s5
    jal map_plaintext

p7_key_sort_matrix:
    # keyword = sorting key
    # s5 = address of heap
    # num rows = heap size / keyword length
    # num cols = keyword length
    move $a0, $s5
    div $s4, $s6 # heap size / keyword length
    mflo $a1
    move $a2, $s6
    move $a3, $s2
    addi $sp, $sp, -4
    li $t0, 1
    sw $t0, 0($sp)
    jal key_sort_matrix
    addi $sp, $sp, 4

p7_transpose:
    move $a0, $s5
    move $a1, $s3
    div $s4, $s6 
    mflo $a2
    move $a3, $s6
    jal transpose

p7_add_null_terminator:
    add $t0, $s4, $s3 #add address + heap size
    sb $0, ($t0)

lw $ra, 0($sp)
lw $s6, 4($sp)
lw $s5, 8($sp)
lw $s4, 12($sp)
lw $s3, 16($sp)
lw $s2, 20($sp)
lw $s1, 24($sp)
lw $s0, 28($sp)
addi $sp, $sp, 32
jr $ra

# Part VIII
lookup_char:
# a0 = adfgvx grid
# a1 = row char
# a2 = col char

addi $sp, $sp, -16
sw $s0, 12($sp)
sw $s1, 8($sp)
sw $s2, 4($sp)
sw $ra, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2

move $a0, $s1 # test row char
jal p8_helper
beq $v0, -1, p8_error_case
move $s1, $v0 # move row index to s1

move $a0, $s2 # test col char
jal p8_helper
beq $v0, -1, p8_error_case
move $s2, $v0 # move col index to s2

# valid characters

#adfgvx grid is 6x6 --> num cols = 6
# index of letter = 6 * i + j
li $t0, 6
mult $t0, $s1
mflo $t0
add $t0, $t0, $s2 # proper index = t0
add $t0, $t0, $s0 # add base address

lbu $v1, ($t0)
li $v0, 0

j p8_done

p8_error_case:
    li $v0, -1
    li $v1, -1

p8_done:
    lw $ra, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# Part IX
string_sort:
# a0 = string to sort

# get string length first
li $t0, 0 # n = 0
move $t1, $a0
p9_traverse_string:
    lbu $t2, ($t1)
    beqz $t2, p9_start_loop_i
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j p9_traverse_string

p9_start_loop_i:
li $t1, 0 # i = 0
p9_loop_i:
    bge $t1, $t0, p9_done

    addi $t3, $t0, -1 # t3 = n - 1
    sub $t3, $t3, $t1 # t3 = (n - 1) - i
    li $t2, 0 # j = 0
    p9_loop_j:
        bge $t2, $t3, p9_continue_i

        move $t4, $t2 # t4 = j
        addi $t5, $t4, 1 # t5 = j + 1
        add $t4, $t4, $a0 # add base address
        add $t5, $t5, $a0 # add base address
        lbu $t6, ($t4)
        lbu $t7, ($t5)
        # if A[j] <= A[j + 1]
        ble $t6, $t7, p9_continue_j
        # A[j] > A[j + 1]
        # swap
        sb $t6, ($t5)
        sb $t7, ($t4)
        
        p9_continue_j:
            addi $t2, $t2, 1
            j p9_loop_j

    p9_continue_i:
    addi $t1, $t1, 1
    j p9_loop_i

p9_done:
    jr $ra

# Part X
decrypt:
# a0 = adfgvx grid
# a1 = null terminated ciphertext
# a2 = keyword
# a3 = plaintext space
addi $sp, $sp, -36
sw $s0, 32($sp)
sw $s1, 28($sp)
sw $s2, 24($sp)
sw $s3, 20($sp)
sw $s4, 16($sp)
sw $s5, 12($sp)
sw $s6, 8($sp)
sw $s7, 4($sp)
sw $ra, 0($sp)

move $s0, $a0 
move $s1, $a1
move $s2, $a2
move $s3, $a3
# s4 = length of keyword
# s5 = heap_keyword address
# s6 = heap_keyword_indices address
# s7 = heap_ciphertext address

li $s4, 0
move $t0, $s2 # t0 = used to traverse keyword
p10_loop_keyword:
    lbu $t1, ($t0)
    beqz $t1, p10_copy_keyword_setup
    addi $t0, $t0, 1
    addi $s4, $s4, 1
    j p10_loop_keyword

p10_copy_keyword_setup:
    move $a0, $s4
    li $v0, 9
    syscall
    move $s5, $v0 # s5 = heap_keyword

    li $t0, 0
    p10_copy_keyword:
        bge $t0, $s4, p10_sort_heap_keyword

        add $t1, $t0, $s2
        add $t2, $t0, $s5
        lb $t3, ($t1)
        sb $t3, ($t2)

        addi $t0, $t0, 1
        j p10_copy_keyword

p10_sort_heap_keyword:
    move $a0, $s5
    jal string_sort

p10_create_heap_keyword_indices:
    sll $t0, $s4, 2
    # multiply keyword length by 4, one word for each integer
    move $a0, $t0
    li $v0, 9
    syscall
    move $s6, $v0 # s6 = heap_keyword_indices

    li $s7, 0 # s7 = temp variable  = i
    p10_loop_keyword_indices:
        bge $s7, $s4, p10_transpose_matrix_setup

        add $t1, $s7, $s5 # heap_keyword[i]

        move $a0, $s2
        lbu $a1, ($t1)
        jal p10_helper

        sll $t0, $s7, 2
        add $t1, $t0, $s6 # heap_keyword_indices[i]
        sw $v0, ($t1)

        addi $s7, $s7, 1
        j p10_loop_keyword_indices

p10_transpose_matrix_setup:
    # interpret cipthertext array as (keyword_length) rows * (cipthertext array size / keyword_length) cols

    # get size of ciphtertext
    li $s7, 0 # s7 = temp variable for now
    move $t1, $s1 # t1 = used to traverse ciphertext
    p10_loop_ciphertext:
        lbu $t2, ($t1)
        beqz $t2, p10_create_ciphertext_array
        addi $s7, $s7, 1
        addi $t1, $t1, 1
        j p10_loop_ciphertext


    p10_create_ciphertext_array:
        # allocate 2D array on heap 
        move $a0, $s7
        li $v0, 9
        syscall
        move $s2, $s7 # move ciphertext length to s2 (no longer need keyword)
        move $s7, $v0 # s7 = heap_ciphertext_array


    p10_transpose_matrix:
        div $s2, $s4 # divide ciphertext array length by keyword length

        move $a0, $s1 # matrix src
        move $a1, $s7 # matrix dest
        move $a2, $s4 # matrix src num rows
        mflo $a3 # matrix src num cols
        jal transpose

    p10_unsort_matrix:
        div $s2, $s4 # divide ciphertext array length by keyword length
        # matrix = heap_cipher_text_array
        # num rows = ciphtertext array length / keyword length
        # num cols = keyword length
        # key = heap_keyword_indices
        # elem size
        move $a0, $s7
        mflo $a1
        move $a2, $s4
        move $a3, $s6
        addi $sp, $sp, -4
        li $t0, 4 # 4 = array of words (integers)
        sw $t0, 0($sp)
        jal key_sort_matrix
        addi $sp, $sp, 4

    p10_decode:
        #until it reaches a * at the end
        p10_decode_loop:
            lbu $t0, ($s7)
            beq $t0, '*', p10_append_null
            beqz $t0, p10_append_null

            addi $s7, $s7, 1
            lbu $t1, ($s7)

            move $a0, $s0
            move $a1, $t0 # row char
            move $a2, $t1 # col char
            jal lookup_char

            # character in v1
            sb $v1, ($s3)

            addi $s7, $s7, 1
            addi $s3, $s3, 1
            j p10_decode_loop

        p10_append_null:
            sb $0, ($s3)
            #put a null terminator


lw $ra, 0($sp)
lw $s7, 4($sp)
lw $s6, 8($sp)
lw $s5, 12($sp)
lw $s4, 16($sp)
lw $s3, 20($sp)
lw $s2, 24($sp)
lw $s1, 28($sp)
lw $s0, 32($sp)
addi $sp, $sp, 36


jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
