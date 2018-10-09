.include "data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
most_popular_feature_output: .asciiz "most_popular_feature output: "

.text
.globl main
main:
la $a0, most_popular_feature_output
li $v0, 4
syscall
la $a0, all_cars
# original
# li $a1, 6
# li $a2, 12
# Test 1 --> expected return value = 8
# li $a1, 6
# li $a2, 15
# Test 2 --> expected return value = 4
# li $a1, 6
# li $a2, 7
# Test 3 --> expected return value = 2
# li $a1, 6
# li $a2, 3
# Test 4 --> expected return value = 4
# li $a1, 6
# li $a2, 5
# Test 5 --> expected return value = 1
# li $a1, 6
# li $a2, 1
# Test 6 --> expected return value = -1
# li $a1, 6
# li $a2, 0
# Test 7 --> expected return value = -1
li $a1, -1
li $a2, 14
# Test if no car has feature vector  FIXME
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
syscall
