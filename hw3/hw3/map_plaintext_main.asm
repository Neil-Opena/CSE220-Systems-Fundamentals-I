.data
adfgvx_grid: .asciiz "IQSP4TONLZJUGACHXVE73WKY5MB126980FRD"
plaintext: .asciiz "STONYBROOKUNIV"
middletext_buffer: .asciiz "???????????????????????????????"
plaintext_1: .asciiz "STORMLIGHT"
middletext_buffer_1: .asciiz "**************************"

.text
.globl main
main:
########################################
la $a0, adfgvx_grid
la $a1, plaintext
la $a2, middletext_buffer
jal map_plaintext
la $a0, middletext_buffer
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall
########################################
la $a0, adfgvx_grid
la $a1, plaintext_1
la $a2, middletext_buffer_1
jal map_plaintext
la $a0, middletext_buffer_1
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11

li $v0, 10
syscall

.include "hw3.asm"
