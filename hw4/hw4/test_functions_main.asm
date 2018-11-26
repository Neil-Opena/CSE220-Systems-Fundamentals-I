.data
map_filename: .asciiz "CSE220-Github/hw4/hw4/map3.txt"
map_filename_monsters: .asciiz "CSE220-Github/hw4/hw4/map3_modified.txt"
map: .word 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 
player: .word 0x2912FECD

.text

.globl main
main:
la $a0, map_filename
la $a1, map
la $a2, player
jal init_game

# ############################
# # Is Valid Cell
# ############################
# la $a0, map
# li $a1, 5
# li $a2, 3
# jal is_valid_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 0
# li $a2, 0
# jal is_valid_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 6
# li $a2, 24
# jal is_valid_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 25
# li $a2, 3
# jal is_valid_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, -3
# li $a2, 4
# jal is_valid_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################


# ############################
# # Get the Contents of a Cell
# ############################
# la $a0, map
# li $a1, 26
# li $a2, 7
# jal get_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, -1
# li $a2, 3
# jal get_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 0
# li $a2, 0
# jal get_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 0
# li $a2, 7
# jal get_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 3
# li $a2, 2
# jal get_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################

# ###########################
# # Set the Contents of a Cell 
# ###########################
# la $a0, map
# li $a1, 26
# li $a2, 7
# li $a3, '$'
# jal set_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, -1
# li $a2, 3
# li $a3, '.'
# jal set_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 0
# li $a2, 0
# li $a3, '$'
# jal set_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 0
# li $a2, 7
# li $a3, '.'
# jal set_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################
# la $a0, map
# li $a1, 3
# li $a2, 2
# li $a3, '$'
# jal set_cell
# move $a0, $v0
# li $v0, 1
# syscall
# li $a0, '\n'
# li $v0, 11
# syscall
# ############################

# ###########################
# Reveal the Contents of a Cell 
# ########################### test one at a time for this
# la $a0, map
# li $a1, 6
# li $a2, 4
# jal reveal_area
############################
# la $a0, map
# li $a1, -1
# li $a2, 0
# jal reveal_area
# ############################
# la $a0, map
# li $a1, -2
# li $a2, -1
# jal reveal_area
############################

# ###########################
# Acquiring a Target to Attack
# ########################### # test with new map, uncomment andi line 
la $a0, map_filename_monsters
la $a1, map
la $a2, player
jal init_game
############################ expected = -1 (cannot attack a wall)
la $a0, map
la $a1, player
li $a2, 'U'
jal get_attack_target
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
############################ expected = ascii value of B = 66
la $a0, map
la $a1, player
li $a2, 'D'
jal get_attack_target
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
############################ expected = -1 (invalid index)
la $a0, map
la $a1, player
li $a2, 'L'
jal get_attack_target
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
############################ expected = ascii value of m = 109
la $a0, map
la $a1, player
li $a2, 'R'
jal get_attack_target
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
############################ expected = -1 (invalid argument)
la $a0, map
la $a1, player
li $a2, 'Z'
jal get_attack_target
move $a0, $v0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
############################

exit:
li $v0, 10
syscall

.include "hw4.asm"