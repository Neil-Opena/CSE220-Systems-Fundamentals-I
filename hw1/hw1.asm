
# Neil Opena
# nopena
# 110878452

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
zero_str: .asciiz "Zero\n"
neg_infinity_str: .asciiz "-Inf\n"
pos_infinity_str: .asciiz "+Inf\n"
NaN_str: .asciiz "NaN\n"
floating_point_str: .asciiz "_2*2^"

# Miscellaneous strings
nl: .asciiz "\n"

# Put your additional .data declarations here, if any.

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beq $a0, 0, zero_args # go to label if 0 args provided
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0 # addr_arg0 will contain the first command-line argument
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory
    
start_coding_here:
    # Start the assignment by writing your code here
    lw $s0, addr_arg0 # $s0 = first argument = starting address of the strings
    move $s4, $a0 # move number of arguments to s4

    # Checking the length of the first argument
    li $s1, 0 # length counter = $s1 = 0 

    lbu $s3, ($s0) # contains the first character of the first argument

    count_arg0_length:  #loop (count length of arg0)
        lbu $t0, ($s0) 
        beqz $t0, done_counting # null terminator reached
        addi $s1, $s1, 1 # increment counter
        addi $s0, $s0, 1 # advance to the next character
        j count_arg0_length

    done_counting:
    # if number > 1: error
        bgt $s1, 1 print_invalid_operation_error
    
    # else check if first argument is F, C or 2
    verify_arg0:
        li $s0, 70 # 'F'
        li $s1, 67 # 'C'
        li $s2, 50 # '2' == 50 in decimal
        beq $s0, $s3, arg0_is_F
        beq $s1, $s3, arg0_is_C
        beq $s2, $s3, arg0_is_2 
        # not equal to F, C or 2
        j print_invalid_operation_error

    arg0_is_F:
        # there must be exactly one other argument --> $s4 should be 2
        bne $s4, 2, print_invalid_args_error

        # interpret as string of hexadecimal digits
        lw $s0, addr_arg1
        li $s1, 0 # hexadecimal character counter

        verify_hexadecimal_string:
            # count the input string, cannot be less than or greater than 8
            lbu $s2, ($s0)
            bgt $s1, 8, print_invalid_args_error
            beqz $s2, check_if_less
            # check each character
            #####
            addi $s1, $s1, 1 # increment counter
            addi $s0, $s0, 1 # go to next character
            
            j verify_hexadecimal_string

        check_if_less:
            blt $s1, 8, print_invalid_args_error

        j exit

    arg0_is_2:
        # there must be exactly one other argument --> $s4 should be 2
        bne $s4, 2, print_invalid_args_error

        # interpret as two's complement number
        lw $s0, addr_arg1
        li $s1, 0 # 2s complement counter
        li $s3, 0 # contains the actually binary, not the string

        verify_2s_complement:
            # count the input string, cannot be greater than 32, can only be '1' or '0'
            lbu $s2, ($s0)
            bgt $s1, 32, print_invalid_args_error # counter greater than 32
            beqz $s2, check_sign
            # need a way to verify if '1' or '0'
            # 48 == '0', 49 == '1'
            blt $s2, 48, print_invalid_args_error 
            bgt $s2, 49, print_invalid_args_error
            addi $s1, $s1, 1 # increment counter
            addi $s0, $s0, 1 # go to next character
            
            sll $s3, $s3, 1 # shift makes room
            addi $t0, $s2, -48 # get 0 or 1
            add $s3, $s3, $t0 # 'append'
            
            j verify_2s_complement


        check_sign:
            # first look at msb (0 == positive)
            lw $s0, addr_arg1
            lbu $s2, ($s0)
            beq $s2, 48, print_2s_complement

            #logic is wrong
            # there should be 22 1s starting from msb

            li $t0, 0 
            append_1s: 
                beqz $s1, sign_extend #s1 = num of inputs
                sll $t0, $t0, 1
                addi $t0, $t0, 1
                addi $s1, $s1, -1
                j append_1s  # continually append 1s 

            sign_extend:
                xori $t0, $t0, 0xFFFFFFFF  # flip 1s to 0s
                or $s3, $s3, $t0

        print_2s_complement:
            move $a0, $s3
            li $v0, 1
            syscall
            j exit

    arg0_is_C:
        # the must be exactly three other arguments --> $s4 should be 4
        bne $s4, 4, print_invalid_args_error
        j exit

    print_invalid_operation_error:
        la $a0, invalid_operation_error
        li $v0, 4
        syscall
        j exit

    print_invalid_args_error:
        la $a0, invalid_args_error
        li $v0, 4
        syscall
        j exit

exit:
    li $v0, 10   # terminate program
    syscall
