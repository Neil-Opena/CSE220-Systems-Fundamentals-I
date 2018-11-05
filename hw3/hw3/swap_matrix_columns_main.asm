.data
chars: .ascii "IQSP4TONLZJUGACHXVE73WKY"

.text
.globl main
main:
# num rows = 0 -> -1
la $a0, chars
li $a1, 0
li $a2, 4
li $a3, 0
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# num rows = -1 -> -1
la $a0, chars
li $a1, -1
li $a2, 4
li $a3, 0
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# num cols = 0 -> -1
la $a0, chars
li $a1, 6
li $a2, 0
li $a3, 0
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# num cols = -1 -> -1
la $a0, chars
li $a1, 6
li $a2, -1
li $a3, 0
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# col1 < 0
la $a0, chars
li $a1, 6
li $a2, 4
li $a3, -1
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# col1 > num cols
la $a0, chars
li $a1, 6
li $a2, 4
li $a3, 5
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# col1 = num cols
la $a0, chars
li $a1, 6
li $a2, 4
li $a3, 4
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# col2 < 0
la $a0, chars
li $a1, 6
li $a2, 4
li $a3, 0
addi $sp, $sp, -4
li $t0, -1  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# col2 > num cols
la $a0, chars
li $a1, 6
li $a2, 4
li $a3, 0
addi $sp, $sp, -4
li $t0, 5  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# col2 = num cols ->
la $a0, chars
li $a1, 6
li $a2, 4
li $a3, 0
addi $sp, $sp, -4
li $t0, 4  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall


la $a0, chars
li $a1, 6
li $a2, 4
li $a3, 0
addi $sp, $sp, -4
li $t0, 2  # 5th argument to function
sw $t0, 0($sp)
jal swap_matrix_columns
addi $sp, $sp, 4
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

# expected: SQIPOT4NJZLUCAGHEVX7KW3Y
la $a0, chars
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "hw3.asm"
