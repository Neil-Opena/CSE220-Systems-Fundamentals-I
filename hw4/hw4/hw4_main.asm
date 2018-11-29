.data
map_filename: .asciiz "CSE220-Github/hw4/hw4/map3.txt"
# num words for map: 45 = (num_rows * num_cols + 2) // 4 
# map is random garbage initially
.asciiz "Don't touch this region of memory"
map: .word 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 
.asciiz "Don't touch this"
# player struct is random garbage initially
player: .word 0x2912FECD
.asciiz "Don't touch this either"
# visited[][] bit vector will always be initialized with all zeroes
# num words for visited: 6 = (num_rows * num*cols) // 32 + 1
visited: .word 0 0 0 0 0 0 
.asciiz "Really, please don't mess with this string"

welcome_msg: .asciiz "Welcome to MipsHack! Prepare for adventure!\n"
pos_str: .asciiz "Pos=["
health_str: .asciiz "] Health=["
coins_str: .asciiz "] Coins=["
your_move_str: .asciiz " Your Move: "
you_won_str: .asciiz "Congratulations! You have defeated your enemies and escaped with great riches!\n"
you_died_str: .asciiz "You died!\n"
you_failed_str: .asciiz "You have failed in your quest!\n"

.text
print_map:
la $t0, map  # the function does not need to take arguments

lbu $t1, 0($t0) # t1 = num rows
lbu $t2, 1($t0) # t2 = num cols
addi $t0, $t0, 2 # t0 = cells[0][0]

li $v0, 11 # syscall setup
li $t5, 0 # t5 = row counter
print_map_row_loop:
    bge $t5, $t1, done_printing_map_row

    li $t4, 0 # t4 = col counter
    print_map_col_loop:
        bge $t4, $t2, continue_print_row
        lbu $a0, ($t0)
        andi $t6, $a0, 0x80
        # 1 == hidden from the player
        beqz $t6, not_hidden
        li $a0, ' '

        not_hidden:
        syscall
        addi $t0, $t0, 1
        addi $t4, $t4, 1
        j print_map_col_loop

    continue_print_row:
        # print newline 
        li $a0, '\n'
        syscall
        addi $t5, $t5, 1
        j print_map_row_loop

done_printing_map_row:
    jr $ra

print_player_info:
# the idea: print something like "Pos=[3,14] Health=[4] Coins=[1]"
la $t0, player

li $v0, 4
la $a0, pos_str
syscall

# get row
li $v0, 1
lbu $a0, 0($t0)
syscall
# print comma
li $v0, 11
li $a0, ','
syscall
# get col
li $v0, 1
lbu $a0, 1($t0)
syscall

li $v0, 4
la $a0, health_str
syscall

# get health (signed)
li $v0, 1
lb $a0, 2($t0)
syscall

li $v0, 4
la $a0, coins_str
syscall

# get coins
li $v0, 1
lbu $a0, 3($t0)
syscall

# print bracket and newline
li $v0, 11
li $a0, ']'
syscall
li $a0, '\n'
syscall

jr $ra


.globl main
main:
la $a0, welcome_msg
li $v0, 4
syscall

# fill in arguments
la $a0, map_filename
la $a1, map
la $a2, player
jal init_game

# fill in arguments
la $a0, map # map ptr
la $t0, player
lbu $a1, 0($t0) # player row
lbu $a2, 1($t0) # player col
jal reveal_area

li $s0, 0  # move = 0
game_loop:  # while player is not dead and move == 0:

    jal print_map # takes no args
    jal print_player_info # takes no args

    # print prompt
    la $a0, your_move_str
    li $v0, 4
    syscall

    li $v0, 12  # read character from keyboard
    syscall
    move $s1, $v0  # $s1 has character entered
    li $s0, 0  # move = 0

    li $a0, '\n'
    li $v0 11
    syscall

    # handle input: w, a, s or d
    # map w, a, s, d  to  U, L, D, R and call player_turn()
    beq $s1, 'w', go_up
    beq $s1, 's', go_down
    beq $s1, 'a', go_left
    beq $s1, 'd', go_right

    j game_loop

    go_up:
        la $a0, map
        la $a1, player
        li $a2, 'U'
        jal player_turn
        j continue_game_loop

    go_down:
        la $a0, map
        la $a1, player
        li $a2, 'D'
        jal player_turn
        j continue_game_loop

    go_left:
        la $a0, map
        la $a1, player
        li $a2, 'L'
        jal player_turn
        j continue_game_loop

    go_right:
        la $a0, map
        la $a1, player
        li $a2, 'R'
        jal player_turn
        j continue_game_loop

    continue_game_loop:
        move $s0, $v0

        # handle char == 'r'
        # if move == 0, call reveal_area()  Otherwise, exit the loop.
        bne $s0, $0, exit_loop
        la $t0, player
        # check player health
        lb $t1, 2($t0) # t1 = health
        ble $t1, $0, exit_loop
        la $a0, map
        lbu $a1, 0($t0)
        lbu $a2, 1($t0)
        jal reveal_area

        j game_loop

exit_loop:

game_over:
jal print_map
jal print_player_info
li $a0, '\n'
li $v0, 11
syscall

# choose between (1) player dead, (2) player escaped but lost, (3) player escaped and won
la $t0, player
lb $t1, 2($t0)
ble $t1, $0, player_dead

li $t1, 3
lbu $t2, 3($t0)
blt $t2, $t1, failed

won:
la $a0, you_won_str
li $v0, 4
syscall
j exit

failed:
la $a0, you_failed_str
li $v0, 4
syscall
j exit

player_dead:
la $a0, you_died_str
li $v0, 4
syscall

exit:
li $v0, 10
syscall

.include "hw4.asm"
