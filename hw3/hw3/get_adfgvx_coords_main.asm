.text
.globl main
main:

# (1,4) --> return (D, V)
li $a0, 1
li $a1, 4
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (5,3) --> return (X, G)
li $a0, 5
li $a1, 3
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (-2,1) --> return (-1, -1)
li $a0, -2
li $a1, 1
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (4,7) --> return (-1, -1)
li $a0, 4
li $a1, 7
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (8,-3) --> return (-1, -1)
li $a0, 8
li $a1, -3
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (-1, -1) --> return  (-1, -1)
li $a0, -1
li $a1, -1
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (0, 0) --> return ('A', 'A')
li $a0, 0
li $a1, 0
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (-1, 0) --> return (-1, -1)
li $a0, -1
li $a1, 0
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall
# (0, -1)
li $a0, 0
li $a1, -1
jal get_adfgvx_coords
move $a0, $v0
li $v0, 11
syscall
li $a0, ' '
syscall
move $a0, $v1
syscall
li $a0, '\n'
syscall

li $v0, 10
syscall

.include "hw3.asm"
