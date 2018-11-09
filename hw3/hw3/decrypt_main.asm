.data
adfgvx_grid: .asciiz "NA1CEH8TB2OM35WRPD4F6G7I9J0KLQSUVXYZ"
ciphertext: .asciiz "XDDDAAXAV*AXDFXDXFVFDDGFXGVVG*VDDF*"
keyword: .asciiz "KNIGHTS"
plaintext: .ascii "?????????????????"  # result is 16 chars + null-terminator
.asciiz "!!!!!!"


grid1: .asciiz "NA1C3H8TB2OME5WRPD4F6G7I9J0KLQSUVXYZ"
cipher1: .asciiz "DGDDDAGDDGAFADDFDADVDVFAADVX"
key1: .asciiz "PRIVACY"
plaintext1: .asciiz "?????????????????"
.asciiz "!!!!!!"


cipher2: .asciiz "XXGXDGVDAVGAADFDADVGGVADDFGAGFFVDADGXAGAFVAVDVAXVDXVVDXA"
key2: .asciiz "KNIGHTS"
plaintext2: .asciiz "????????????????????????????????????????????????????????????"
.asciiz "!!!!!!"

cipher3: .asciiz "AVD*VDX*AVA*DVG*GVVXGXX*AGAVXFXADFF*"
key3: .asciiz "SBU2018NY"
plaintext3: .asciiz "????????????????????????????????????????"
.asciiz "!!!!!!"

.text
.globl main
main:
la $a0, adfgvx_grid
la $a1, ciphertext
la $a2, keyword
la $a3, plaintext
jal decrypt
la $a0, plaintext
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall
##########################
la $a0, grid1
la $a1, cipher1
la $a2, key1
la $a3, plaintext1
jal decrypt
la $a0, plaintext1
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall
##########################
la $a0, adfgvx_grid
la $a1, cipher2
la $a2, key2
la $a3, plaintext2
jal decrypt
la $a0, plaintext2
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall
##########################
la $a0, adfgvx_grid
la $a1, cipher3
la $a2, key3
la $a3, plaintext3
jal decrypt
la $a0, plaintext3
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "hw3.asm"
