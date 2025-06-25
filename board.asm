.data
    choice1: .asciiz "Choose a token to flip 0-15: "
    choice2: .asciiz "Choose a second token to match 0-15: "
    invalid_Input_Msg: .asciiz "\nCannot choose that. Try again. \n"
    skipLine: .asciiz "\n"
    space_tile: .asciiz "  "
    hidden: .asciiz "[ ]"
    line: .asciiz "\n---------------------------\n"
    top: .asciiz "---"        
    middle: .asciiz "---"    
    bottom: .asciiz "--"
    row: .asciiz ""
    row2: .asciiz ""

.text
    .globl display_matrix
    .globl get_input

display_matrix:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)

    li $s0, 0
    li $s1, 0
    la $s2, matrix
    la $s3, eq_sol_allocation

    li $t8, 0
    li $t9, 3

display_row:
    la $a0, skipLine
    li $v0, 4
    syscall

loop_start:
    bgt $t8, $t9, end_loop

    la $a0, top
    li $v0, 4
    syscall

    move $a0, $t8
    li $v0, 1
    syscall

    bgt $t8, 9, display_bottom

    la $a0,middle
    li $v0, 4
    syscall
    j counter

display_bottom:
    la $a0, bottom
    li $v0, 4
    syscall

counter:
    addi $t8, $t8, 1
    j loop_start

end_loop:
    addi $t9, $t9, 4

    la $a0, skipLine
    li $v0, 4
    syscall

    la $a0, row
    li $v0, 4
    syscall

    li $t0, 0

display_tile:
    la $t1, found_matches
    add $t1, $t1, $s1
    lb $t2, ($t1)

    la $a0, space_tile
    li $v0, 4
    syscall

    beqz $t2, display_hidden

    mul $t3, $s1, 5
    add $t4, $s3, $t3

    li $t5, 5
display_label:
    lb $a0, ($t4)
    li $v0, 11
    syscall
    addi $t4, $t4, 1
    addi $t5, $t5, -1
    bgtz $t5, display_label

    j next

display_hidden:
    la $a0, hidden
    li $v0, 4
    syscall

    la $a0, space_tile
    li $v0, 4
    syscall

next:
    la $a0, row2
    li $v0, 4
    syscall

    addi $t0, $t0, 1
    addi $s1, $s1, 1
    blt $t0, 4, display_tile

    addi $s0, $s0, 1
    blt $s0, 4, display_row

    la $a0, line
    li $v0, 4
    syscall

    lw $ra, 12($sp)
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

get_input:
    addi $sp, $sp, -4
    sw $ra, ($sp)

    li $v0, 4
    la $a0, choice1
    syscall

    li $v0, 5
    syscall

    bltz $v0, input_Error
    bge $v0, 16, input_Error
    
    la $t0, found_matches
    add $t0, $t0, $v0
    lb $t1, ($t0)
    bnez $t1, input_Error

    move $t2, $v0

    li $v0, 4
    la $a0, choice2
    syscall

    li $v0, 5
    syscall

    bltz $v0, input_Error
    bge $v0, 16, input_Error

    la $t0, found_matches
    add $t0, $t0, $v0
    lb $t1, ($t0)
    bnez $t1, input_Error

    beq $v0, $t2, input_Error

    move $a1, $v0
    move $a0, $t2

    lw $ra, ($sp)
    addi $sp, $sp, 4
    jr $ra

input_Error:
    li $v0, 4
    la $a0, invalid_Input_Msg
    syscall

    addi $sp, $sp, 4
    j get_input
