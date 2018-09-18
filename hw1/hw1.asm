
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
float_string_before_exponent: .asciiz "**************************" #3 for possible -1., 23 for mantissa
negative_sign: .asciiz "-"

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
        li $s3, 0 # container for hexadecimal value

        verify_hexadecimal_string:
            # count the input string, cannot be less than or greater than 8
            lbu $s2, ($s0)
            bgt $s1, 8, print_invalid_args_error
            beqz $s2, check_if_less
            # check each character
            # [48 - 57] = "0" - "9"
            # [65 - 70] = "A" - "F"
            # if ( val < 48 ) error
            # if (val > 70) error

            # if (val < 65) && (val > 57) error
            blt $s2, 48, print_invalid_args_error
            bgt $s2, 70, print_invalid_args_error

            blt $s2, 65, continue_check
            valid_hex_character:
                addi $s2, $s2, -7 # subtract 7 so conversion is correct
            
            valid_hex_integer:
                addi $s2, $s2, -48

            convert_hex:
                sll $s3, $s3, 4
                add $s3, $s3, $s2 

            addi $s1, $s1, 1 # increment counter
            addi $s0, $s0, 1 # go to next character
            
            j verify_hexadecimal_string

        continue_check:
            bgt $s2, 57, print_invalid_args_error
            j valid_hex_integer

        check_if_less:
            blt $s1, 8, print_invalid_args_error

        # 1 - sign bit
        la $s2, float_string_before_exponent # s2 = floating string address
        la $s1, negative_sign # s1 negative sign address
        lbu $t0, ($s1)

        #get the sign bit first
        andi $s0, $s3, 0x80000000 #s0 = contains information about sign
        beqz $s0, get_exponent
        # negative
        sb $t0, ($s2)
        addi $s2, $s2, 1 # proceed to next byte address of string

        # exponent range - 126 to 127 before bias
        # first get 8 bits corresponding to exponent 0111 1111 1000 0000 0000 0000 0000 0000 --> 0x7F800000

        # it might be better to calculate the exponent before the mantissa --> go straight to special cases
        get_exponent:
            move $t1, $s0 # move sign bit information to t1
            move $s0, $s3 # clean things up --> move hexadecimal value to $s3
            andi $s1, $s0, 0x7F800000  # s1 = exponent prior to bias subtraction
            # need to convert to numerical value --> sra 23 times
            li $t0, 23

            convert_exponent_num:
                beqz $t0, check_special_cases
                sra $s1, $s1, 1
                addi $t0, $t0, -1
                j convert_exponent_num

            check_special_cases:
                beqz $s1, print_hex_zero 
                beq $s1, 0x000000FF, print_hex_f_exponent

            subtract_bias: 
                addi $s4, $s1, -127


        get_fraction:
            # get a '1' and a '.' inserted
            li $t0, 49 # t0 = ascii value for 1
            li $t1, 46 # t1 = ascii value for .
            sb $t0, ($s2)
            addi $s2, $s2, 1 # proceed to next byte address 
            sb $t1, ($s2)

        #get mantissa = 23 bits
        # get last 6 characters
        # dont forget to store the first bit of the 3rd character as the last bit of the exponent
        # to get last 23 bits --> mask with and 0000 0000 0111 F F F F F

        andi $s1, $s0, 0x007FFFFF #s1 contains the fractional part

        addi $s2, $s2, 1
        #s2 = current 'index'

        #  need a way to convert the fractional part (hex) into binary
        # need a way to read in each binary digit
        # start with 0000 0000 0100 0000 0000 0000 0000 0000 = 0x00400000 and sra moving the 1 bit to each spot
        # if 0 write 0, else write 1
        # save the andi result and save into byte address 

        li $t1, 0 # t1 = result of and operation
        li $t2, 0x00400000
        li $s3, 0 
        li $t0, 23 # counter for 23 bits
        read_mantissa:
            beqz $t0, print_floating_point_str
            and $t1, $s1, $t2
            bgt $t1, $s3, result_1
            #write 0
            write_binary:
            addi $t1, $t1, 48
            sb $t1, ($s2)
            sra $t2, $t2, 1
            addi $t0, $t0, -1
            addi $s2, $s2, 1 # move index of byte
            j read_mantissa
        
        result_1:
            li $t1, 1
            j write_binary

        # need to store a null pointer in the end
        print_floating_point_str:
            li $s1, 0
            sb $s1, ($s2) # put a null terminator 

            la $a0, float_string_before_exponent # get original starting index
            li $v0, 4
            syscall


        #print exponent part
        la $a0, floating_point_str #print 2_2*2^ part
        syscall
        move $a0, $s4
        li $v0, 1
        syscall
      
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

        lw $s0, addr_arg1 # s0 = addr of to convert

        lw $s1, addr_arg2 # addr of source base
        move $a0, $s1
        li $v0, 84
        syscall
        move $s1, $v0

        lw $s2, addr_arg3 # addr of target base
        move $a0, $s2
        li $v0, 84
        syscall
        move $s2, $v0

        # t2 = max ascii value --> source base + 47
        li $t2, 0
        addi $t2, $s1, 47

        li $t1, 0 # n = number of integer places
        verify_num_to_convert:
            lbu $t0, ($s0)
            beqz $t0, continue_converting_num

            # check if character is valid
            bgt $t0, $t2, print_invalid_args_error

            addi $t1, $t1, 1 # increment n
            addi $s0, $s0, 1 # go to next character
            
            j verify_num_to_convert

        continue_converting_num:
            # go through the string again, but this time - 48 to get the numerical value, and then multiply by the source base raised to the n (which will decrement)
            # store decimal value to register
            lw $s0, addr_arg1 # get original starting index
            li $s3, 0 # s3 = decimal value

            addi $t1, $t1, -1 # decrement n by 1 so that it matches indices
            li $t2, 0

            get_decimal_value:
                move $t2, $t1  # t2, t1 = (n -1)
                li $s4, 1 # s4 = to_multiply current integer with (1 * base * base * ...)
                lbu $t0, ($s0)


                blt $t1, 0, done_converting_decimal

                #unsure about mul instructions
                get_source_exponent:
                    # to_multiply = multiplying source * n
                    beqz $t2, continue_multiply
                    mult $s4, $s1
                    mflo $s4
                    addi $t2, $t2, -1
                j get_source_exponent

                continue_multiply:
                    addi $t0, $t0, -48
                    mult $s4, $t0
                    mflo $s4
                    add $s3, $s3, $s4

                addi $t1, $t1, -1 # decrement i value, which is also the counter
                addi $s0, $s0, 1 # go to next character
            j get_decimal_value

        done_converting_decimal:
            move $s0, $s3 # s0 = decimal value
            li $t0, 0
            sb $t0, ($sp) # place a null terminator at end of stack 
            addi $sp, $sp, -1 
            li $v0, 1 # print integer

            # repeatedly divide and place byte in sp and advance by 4 
            li $t1, 0 # helper variable to determine if stack was used or not
            convert_to_target:
                beqz $s0, print_converted_int # keep dividing until quotient is 0 
                addi $t1, $t1, 1
                div $s0, $s2 # s2 = target base
                mfhi $t0 # remainder
                mflo $s0 # quotient

                sb $t0, ($sp) # put remainder in the stack
                addi $sp, $sp, -1 # advance stack pointer
                j convert_to_target
        
        print_converted_int:
            beqz $t1, print_0 # stack not used --> answer = 0
            addi $sp, $sp, 1 # change stack pointer for retrieval

            lbu $t0, ($sp)
            beqz $t0, exit # ERROR

            move $a0, $t0
            syscall
            j print_converted_int

            # IDEA, what if instead of having a null terminator, and a way to check if stack was used
            # we saved the original stack address, and compare it at the end.....

            # LOOOK AT SHEET AGAIN, instead of using stack just allocated memory


        print_0:
            li $a0, 0
            syscall
            j exit

    print_hex_zero:
        la $a0, zero_str
        li $v0, 4
        syscall
        j exit

    print_hex_f_exponent:
        # need to determine if fractional number is 0 or nah
        andi $s1, $s0, 0x007FFFFF #s1 contains the fractional part
        beqz $s1, print_infinity
        #else Nan
        la $a0, NaN_str
        li $v0, 4
        syscall
        j exit
    
    print_infinity:
        # need to print sign bit first
        beqz $t1, load_pos_infinity_str
        la $a0, neg_infinity_str
        continue_printing_infinity:
        li $v0, 4
        syscall
        j exit

    load_pos_infinity_str:
        la $a0, pos_infinity_str
        j continue_printing_infinity

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
