.data
adfgvx_grid: .asciiz "QWE3RT0YU2IO4PLK9J1HGF5DSAZ86XCVB7NM"
row_char: .byte 'F'
col_char: .byte 'G'

row_char1: .byte 'B'
col_char1: .byte 'A'

row_char2: .byte 'Z'
col_char2: .byte 'Y'

row_char3: .byte 'A'
col_char3: .byte 'A'

row_char4: .byte 'X'
col_char4: .byte 'X'

.text
.globl main
main:
###################
la $a0, adfgvx_grid
lbu $a1, row_char
lbu $a2, col_char
jal lookup_char
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
###################
la $a0, adfgvx_grid
lbu $a1, row_char1
lbu $a2, col_char1
jal lookup_char
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
###################
la $a0, adfgvx_grid
lbu $a1, row_char2
lbu $a2, col_char2
jal lookup_char
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
###################
la $a0, adfgvx_grid
lbu $a1, row_char3
lbu $a2, col_char3
jal lookup_char
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
###################
la $a0, adfgvx_grid
lbu $a1, row_char4
lbu $a2, col_char4
jal lookup_char
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "hw3.asm"
