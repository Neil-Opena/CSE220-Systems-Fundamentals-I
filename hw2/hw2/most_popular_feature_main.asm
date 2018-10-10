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
# Test 1 --> expected return value = 8
la $a0, all_cars
li $a1, 6
li $a2, 15
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 2 --> expected return value = 4
la $a0, all_cars
li $a1, 6
li $a2, 7
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 3 --> expected return value = 2
la $a0, all_cars
li $a1, 6
li $a2, 3
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 4 --> expected return value = 4
la $a0, all_cars
li $a1, 6
li $a2, 5
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 5 --> expected return value = 1
la $a0, all_cars
li $a1, 6
li $a2, 1
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 6 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 0
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 7 --> expected return value = -1
la $a0, all_cars
li $a1, -1
li $a2, 14
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 8 --> expected return value = -1
la $a0, all_cars
li $a1, 0
li $a2, 14
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 9 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 16
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 10 --> expected return value = 4
la $a0, all_cars
li $a1, 6
li $a2, 4
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test if no car has feature vector
# Modified .data
# Test 11 --> expected return value = 8
la $a0, all_cars
li $a1, 6
li $a2, 8
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
# Test 12 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 4
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
# Test 13 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 2
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
# Test 14 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 1
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
# Test 15 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 0
jal most_popular_feature
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
li $v0, 10
syscall
