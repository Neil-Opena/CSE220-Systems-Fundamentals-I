.data
adfgvx_grid: .asciiz "QWE3RT0YU2IO4PLK9J1HGF5DSAZ86XCVB7NM"

.text
.globl main
main:
# (grid, '9') -> (,)
la $a0, adfgvx_grid
li $a1, '9'
jal search_adfgvx_grid
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
# (grid, 'G') -> (3,2)
la $a0, adfgvx_grid
li $a1, 'G'
jal search_adfgvx_grid
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
# (grid, 'X') -> (4,5)
la $a0, adfgvx_grid
li $a1, 'X'
jal search_adfgvx_grid
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
# (grid, '-') -> (-1,-1)
la $a0, adfgvx_grid
li $a1, '-'
jal search_adfgvx_grid
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
# (grid, 'g') -> (-1,-1)
la $a0, adfgvx_grid
li $a1, 'g'
jal search_adfgvx_grid
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
# (grid, 'Q') -> (,)
la $a0, adfgvx_grid
li $a1, 'Q'
jal search_adfgvx_grid
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
# (grid, 'M') -> (,)
la $a0, adfgvx_grid
li $a1, 'M'
jal search_adfgvx_grid
move $a0, $v0
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $v1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "hw3.asm"
