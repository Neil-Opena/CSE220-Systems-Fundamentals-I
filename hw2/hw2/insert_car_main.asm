.include "data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
insert_car_output: .asciiz  "insert_car output: "
test_vin: .asciiz "AAAAABBBBBBBBBBCC"
test_car: .word test_vin
.word make_A
.word model_D
.byte 255, 255
.byte 12, 0

.align 2
expected_all_cars: 
.word vin_00
.word make_A
.word model_A
.byte 110, 7
.byte 8
.byte 0

.word vin_01
.word make_D
.word model_B
.byte 115, 7
.byte 8
.byte 0

.word vin_02
.word make_A
.word model_C
.byte 225, 7
.byte 12
.byte 0

.word test_vin
.word make_A
.word model_D
.byte 255, 255
.byte 12, 0

.word vin_03
.word make_E
.word model_D
.byte 175, 7
.byte 10
.byte 0

.word vin_04
.word make_A
.word model_E
.byte 122, 7
.byte 5
.byte 0

.word vin_05
.word make_C
.word model_F
.byte 150, 7
.byte 10
.byte 0

.text
.globl main

main:
la $a0, insert_car_output
li $v0, 4
syscall
la $a0, all_cars
la $a2, test_car 
# Test 1 --> expected return value = 0
# li $a1, 6 
# li $a3, 3
# Test 2 --> expected return value = 0
# li $a1, 6 
# li $a3, 0
# Test 3 --> expected return value = 0
# li $a1, 6 
# li $a3, 6
# Test 4 --> expected return value = -1
# li $a1, -1
# li $a3, 3
# Test 5 --> expected return value = -1
# li $a1, 6 
# li $a3, -1
# Test 6 --> expected return value = -1
li $a1, 6 
li $a3, 8
jal insert_car
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# # comparing contents
# li $s0, 0
# la $s1, all_cars
# la $s2, expected_all_cars
# loop_all_cars:
#     bge $s0, 6, done_test

#     #get all_cars VIN
#     lw $a0, ($s1)
#     #get expected_cars VIN
#     lw $a1, ($s2)

#     jal strcmp
#     move $a0, $v0
#     li $v0, 1
#     syscall
#     la $a0, nl
#     li $v0, 4
#     syscall
#     # output should be 0

#     addi $s1, $s1, 16
#     addi $s2, $s2, 16
#     addi $s0, $s0, 1
#     j loop_all_cars

done_test:
    li $v0, 10
    syscall
