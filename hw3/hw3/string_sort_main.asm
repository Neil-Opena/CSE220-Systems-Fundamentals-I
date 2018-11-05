.data
str: .asciiz "STONYBROOKUNIVERSITY"
str1: .asciiz "KNIGHTS"
str2: .asciiz "D"

.text
.globl main
main:
##########
la $a0, str
jal string_sort
la $a0, str
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall
##########
la $a0, str1
jal string_sort
la $a0, str1
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall
##########
la $a0, str2
jal string_sort
la $a0, str2
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "hw3.asm"
