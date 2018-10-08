.include "hw2.asm"

.data
nl: .asciiz "\n"
memcpy_output: .asciiz "memcpy output: "
src: .asciiz "ABCDEFGHIJ"
dest: .asciiz "XXXXXXX"

.text
.globl main
main:
la $a0, memcpy_output
li $v0, 4
syscall
la $a0, src
la $a1, dest
#Test 1 --> expected return value 0
# li $a2, 3
# Test 2 --> expected return value 0
# li $a2, 7
#Test 3 --> expected return value -1
# li $a2, -3
#Test 4 --> expected return value -1
li $a2, 0
jal memcpy
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
la $a0, dest
li $v0, 4
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
syscall
