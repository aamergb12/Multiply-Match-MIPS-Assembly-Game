.data
    victory_message: .asciiz "Winner Winner Chicken Dinner!\n"
.text
    .globl main

main:
    jal init_matrix
    jal display_matrix

game_loop:
    jal get_input
    jal match

    jal check_end
    beq $v0, 1, end

    j game_loop

end:
    la $a0, victory_message
    li $v0, 4
    syscall

    li $v0, 10
    syscall
