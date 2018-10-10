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

# Test 1 --> expected return value = 2 
la $a0, all_cars
li $a1, 6
li $a2, 0
li $a3, 2017

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 2 --> expected return value = 2
la $a0, all_cars
li $a1, 6
li $a2, 2
li $a3, 2017

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 3 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 3
li $a3, 2017

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 4 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 0
li $a3, 1950

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 5 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, -2
li $a3, 2017

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 6 --> expected return value = -1
la $a0, all_cars
li $a1, 0
li $a2, 1
li $a3, 2017

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 7 --> expected return value = -1
la $a0, all_cars
li $a1, 6
li $a2, 0
li $a3, 1800

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 8 --> expected return value = 5
la $a0, all_cars
li $a1, 6
li $a2, 0
li $a3, 1942

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 9 --> expected return value = 5
la $a0, all_cars
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

# Test 10 --> expected return value = 3
la $a0, all_cars
li $a1, 6
li $a2, 3
li $a3, 1967

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 11 --> expected return value = 4
la $a0, all_cars
li $a1, 6
li $a2, 3
li $a3, 1914

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 12 --> expected return value = -1 (year = 1884)
la $a0, all_cars
li $a1, 6
li $a2, 0
li $a3, 1884

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# Test 13 --> expected return value = -1 (not in data)
la $a0, all_cars
li $a1, 6
li $a2, 0
li $a3, 1885

jal index_of_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

li $v0, 10
syscall


