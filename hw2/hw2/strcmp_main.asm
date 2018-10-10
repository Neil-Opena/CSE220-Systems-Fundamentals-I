.include "hw2.asm"

.data
nl: .asciiz "\n"
strcmp_output: .asciiz "strcmp output: "

#Test 1 --> expected return value = -3
str1: .asciiz "ABCD"
str2: .asciiz "ABCGG"

#Test 2 --> expected return value = 14
str3: .asciiz "WHOOP!"
str4: .asciiz "WHOA"

#Test 3 --> expected return value = -39
str5: .asciiz "Intel"
str6: .asciiz "pentium"

#Test 4 --> expected return value = 17
str7: .asciiz "STONY"
str8: .asciiz "BROOK"

#Test 5 --> expected return value = -5
str9: .asciiz ""
str10: .asciiz "mouse"

#Test 6 --> expected return value = 10
str11: .asciiz "lonely_guy"
str12: .asciiz ""

#Test 7 --> expected return value = 0
str13: .asciiz "Wolfie"
str14: .asciiz "Wolfie"

#Test 8 --> expected return value = 0
str15: .asciiz ""
str16: .asciiz ""

#Test 9 --> expected return value = 14
str17: .asciiz "happy"
str18: .asciiz "Z"

#Test 10 --> expected return value = -73
str19: .asciiz "WOLF"
str20: .asciiz "WOLFIE"

#Test 11 --> expected return value = 66
str21: .asciiz "StonyBrook"
str22: .asciiz "Stony"

#Test 12 --> expected return value = 1
str23: .asciiz "1"
str24: .asciiz "0"

#Test 13 --> expected return value = -1
str25: .asciiz "0"
str26: .asciiz "1"

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

la $a0, str3
la $a1, str4
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str5
la $a1, str6
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str7
la $a1, str8
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str9
la $a1, str10
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str11
la $a1, str12
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str13
la $a1, str14
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str15
la $a1, str16
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str17
la $a1, str18
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str19
la $a1, str20
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str21
la $a1, str22
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str23
la $a1, str24
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

la $a0, str25
la $a1, str26
jal strcmp
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

li $v0, 10
syscall
