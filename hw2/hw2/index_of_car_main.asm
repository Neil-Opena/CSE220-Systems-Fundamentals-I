.include "data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
index_of_car_output: .asciiz  "index_of_car output: "
.text

.globl main
main:
la $a0, index_of_car_output
li $v0, 4
syscall
la $a0, all_cars

# Test 1 --> expected return value = 2 
# li $a1, 6
# li $a2, 0
# li $a3, 2017

# Test 2 --> expected return value = 2
# li $a1, 6
# li $a2, 2
# li $a3, 2017

# Test 3 --> expected return value = -1
# li $a1, 6
# li $a2, 3
# li $a3, 2017

# Test 4 --> expected return value = -1
# li $a1, 6
# li $a2, 0
# li $a3, 1950

# Test 5 --> expected return value = -1
# li $a1, 6
# li $a2, -2
# li $a3, 2017

# Test 6 --> expected return value = -1
# li $a1, 0
# li $a2, 1
# li $a3, 2017

# Test 7 --> expected return value = -1
# li $a1, 6
# li $a2, 0
# li $a3, 1800

# Test 8 --> expected return value = 5
# li $a1, 6
# li $a2, 0
# li $a3, 1942

# Test 9 --> expected return value = 5
li $a1, 6
li $a2, 5
li $a3, 1942

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
li $v0, 10
syscall


