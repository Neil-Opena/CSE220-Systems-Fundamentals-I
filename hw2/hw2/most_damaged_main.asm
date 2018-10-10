.include "data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
most_damaged_output: .asciiz "most_damaged output: "

.text
.globl main
main:
# Test 1 --> expected return value = -1, -1
la $a0, most_damaged_output
li $v0, 4
syscall
la $a0, all_cars
la $a1, all_repairs
li $a2, 0
li $a3, 0
jal most_damaged
move $a0, $v0
li $v0, 1
syscall
li $v0, 11
li $a0, ' '
syscall
move $a0, $v1
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 2 --> expected return value = -1, -1
la $a0, most_damaged_output
li $v0, 4
syscall
la $a0, all_cars
la $a1, all_repairs
li $a2, 0
li $a3, -1
jal most_damaged
move $a0, $v0
li $v0, 1
syscall
li $v0, 11
li $a0, ' '
syscall
move $a0, $v1
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 3 --> expected return value = -1, -1
la $a0, most_damaged_output
li $v0, 4
syscall
la $a0, all_cars
la $a1, all_repairs
li $a2, -1
li $a3, 0
jal most_damaged
move $a0, $v0
li $v0, 1
syscall
li $v0, 11
li $a0, ' '
syscall
move $a0, $v1
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 4 --> expected return value = -1, -1
la $a0, most_damaged_output
li $v0, 4
syscall
la $a0, all_cars
la $a1, all_repairs
li $a2, -1
li $a3, -1
jal most_damaged
move $a0, $v0
li $v0, 1
syscall
li $v0, 11
li $a0, ' '
syscall
move $a0, $v1
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# EDIT data.asm
# Test 5 --> expected return value = 4, 587
la $a0, most_damaged_output
li $v0, 4
syscall
la $a0, all_cars
la $a1, all_repairs
li $a2, 6
li $a3, 10
jal most_damaged
move $a0, $v0
li $v0, 1
syscall
li $v0, 11
li $a0, ' '
syscall
move $a0, $v1
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

li $v0, 10
syscall
