
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

    # Checking the length of the first argument
    li $s1, 0 # length counter = $s1 = 0 
    li $s2, 1 # max length of first argument

    lbu $s3, ($s0) # contains the first character of the first argument

    count_arg0_length:  #loop (count length of arg0)
        lbu $t0, ($s0) 
        beqz $t0, done_counting # null terminator reached
        addi $s1, $s1, 1 # increment counter
        addi $s0, $s0, 1 # advance to the next character
        j count_arg0_length

    done_counting:
    # if number > 1: error
        bgt $s1 $s2 print_invalid_operation_error
    
    # else check if first argument is F, C or 2
    # overwrite other registers
    verify_arg0:
        li $s0, 70 # 'F'
        li $s1, 67 # 'C'
        li $s2, 50 # '2' == 50 in decimal
        beq $s0, $s3, arg0_is_F
        beq $s1, $s3, arg0_is_C
        beq $s2, $s3, arg0_is_2 #ERROR why?
        # not equal to F, C or 2
        j print_invalid_operation_error

    #testing
    move $a0, $s3
    li $v0, 1

    arg0_is_F:
        j print_arg0

    arg0_is_C:
        j print_arg0

    arg0_is_2:
        j print_arg0

    print_arg0: #DELETE LATER
        move $a0, $s3
        li $v0, 1
        syscall
        j exit

    print_invalid_operation_error:
        la $a0, invalid_operation_error
        li $v0, 4
        syscall

exit:
    li $v0, 10   # terminate program
    syscall
