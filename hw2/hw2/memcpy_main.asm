.include "hw2.asm"

.data
nl: .asciiz "\n"
memcpy_output: .asciiz "memcpy output: "

src1: .asciiz "ABCDEFGHIJ"
dest1: .asciiz "XXXXXXX"

src2: .asciiz "ABCDEFGHIJ"
dest2: .asciiz "XXXXXXX"

src3: .asciiz "ABCDEFGHIJ"
dest3: .asciiz "XXXXXXX"

src4: .asciiz "ABCDEFGHIJ"
dest4: .asciiz "XXXXXXX"

src5: .asciiz "12345"
dest5: .asciiz "XXXXX"

src6: .asciiz "1"
dest6: .asciiz "XXXXX"


.text
.globl main
main:
la $a0, memcpy_output
li $v0, 4
syscall
#Test 1 --> expected return value 0
la $a0, src1
la $a1, dest1
li $a2, 3
jal memcpy
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
la $a0, dest1
li $v0, 4
syscall
la $a0, nl
li $v0, 4
syscall
# Test 2 --> expected return value 0
la $a0, src2
la $a1, dest2
li $a2, 7
jal memcpy
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
la $a0, dest2
li $v0, 4
syscall
la $a0, nl
li $v0, 4
syscall
#Test 3 --> expected return value -1
la $a0, src3
la $a1, dest3
li $a2, -3
jal memcpy
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
la $a0, dest3
li $v0, 4
syscall
la $a0, nl
li $v0, 4
syscall
#Test 4 --> expected return value -1
la $a0, src4
la $a1, dest4
li $a2, 0
jal memcpy
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
la $a0, dest4
li $v0, 4
syscall
la $a0, nl
li $v0, 4
syscall

#Test 5 --> expected return value 12345
la $a0, src5
la $a1, dest5
li $a2, 5
jal memcpy
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
la $a0, dest5
li $v0, 4
syscall
la $a0, nl
li $v0, 4
syscall

#Test 6 --> expected return value 1XXXX
la $a0, src6
la $a1, dest6
li $a2, 1
jal memcpy
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
la $a0, dest6
li $v0, 4
syscall
la $a0, nl
li $v0, 4
syscall

li $v0, 10
syscall
