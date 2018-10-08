.include "hw2.asm"

.data
nl: .asciiz "\n"
strcmp_output: .asciiz "strcmp output: "

#Test 1 --> expected return value = -3
str1: .asciiz "ABCD"
str2: .asciiz "ABA"

#Test 2 --> expected return value = 14
# str1: .asciiz "WHOOP!"
# str2: .asciiz "WHOA"

#Test 3 --> expected return value = -39
# str1: .asciiz "Intel"
# str2: .asciiz "pentium"

#Test 4 --> expected return value = 17
# str1: .asciiz "STONY"
# str2: .asciiz "BROOK"

#Test 5 --> expected return value = -5
# str1: .asciiz ""
# str2: .asciiz "mouse"

#Test 6 --> expected return value = 10
# str1: .asciiz "lonely_guy"
# str2: .asciiz ""

#Test 7 --> expected return value = 0
# str1: .asciiz "Wolfie"
# str2: .asciiz "Wolfie"

#Test 8 --> expected return value = 0
# str1: .asciiz ""
# str2: .asciiz ""

#Test 9 --> expected return value = 14
# str1: .asciiz "happy"
# str2: .asciiz "Z"

#Test 10 --> expected return value = -73
# str1: .asciiz "WOLF"
# str2: .asciiz "WOLFIE"

#Test 11 --> expected return value = 66
# str1: .asciiz "StonyBrook"
# str2: .asciiz "Stony"

.text
.globl main
main:
la $a0, strcmp_output
li $v0, 4
syscall
la $a0, str1
la $a1, str2
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
syscall
