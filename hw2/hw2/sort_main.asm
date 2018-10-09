.include "sort_data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
sort_output: .asciiz  "sort output: "

.text
.globl main
main:
la $a0, sort_output
li $v0, 4
syscall
# # print cars before sort
# li $t0, 0
# la $t1, all_cars

# addi $t1, $t1, 12 # print year
# loop_cars_before:
#     bge $t0, 12, done_before

#     li $v0, 1 # print year
#     lhu $a0, ($t1) # print year
#     syscall

#     li $v0, 4
#     addi $t3, $t1, -4
#     lw $a0, ($t3)
#     syscall
#     la $a0, nl
#     syscall

#     addi $t0, $t0, 1
#     addi $t1, $t1, 16
#     j loop_cars_before

# done_before:
la $a0, all_cars
li $a1, 12
jal sort
move $a0, $v0
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall

# # print cars
# li $t0, 0
# la $t1, all_cars

# addi $t1, $t1, 12 # print year
# loop_cars:
#     bge $t0, 12, done

#     li $v0, 1 # print year
#     lhu $a0, ($t1) # print year
#     syscall

#     li $v0, 4
#     addi $t3, $t1, -4
#     lw $a0, ($t3)
#     syscall
#     la $a0, nl
#     syscall

#     addi $t0, $t0, 1
#     addi $t1, $t1, 16
#     j loop_cars

# done:
li $v0, 10
syscall
