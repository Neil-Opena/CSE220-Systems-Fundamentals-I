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

    # First check the length of the first argument (it is still a string)

    # Have a loop increment a value until the null terminator to get the length of the string
    # Initialize $s1 = 0 = length counter
    li $s1, 0

    count_arg0_length:  #loop (count length of arg0)
        lbu $s2, ($s0)
        beqz $s2, done_counting # null terminator reached
        addi $s1, $s1, 1 # increment counter
        addi $s0, $s0, 1 # advance to the next character
        j count_arg0_length

    done_counting:
    move $a0, $s1
    li $v0, 1
    syscall #testing - print out length of first arg

exit:
    li $v0, 10   # terminate program
    syscall
