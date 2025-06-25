.data
    intro: .asciiz "Math-Match game Mode: Multiply easy"
    newline: .asciiz "\n"
    match_good: .asciiz "Match Found!\n"
    
    .globl matrix
   	 .align 2
    matrix: .space 64
    .globl tiles
    tiles: .word 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8
    .globl eq_sol_allocation
    eq_sol_allocation: .space 80
    eq_and_sol: .asciiz " 3*6   18  7*2   14  4*5   20  6*2   12  8*2   16  2*4   8   5*2   10  2*3    6  "
    .globl matches
    matches: .word 0
    .globl found_matches
    found_matches: .space 16
    

.text
    .globl init_matrix
    .globl match
    .globl check_end

init_matrix:
    la $a0, intro
    li $v0, 4
    syscall

display_exp:
    la $t1, eq_and_sol
    j save

save:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    la $t0, eq_sol_allocation
    li $t2, 0
    li $t3, 80

copy:
    lb $t4, ($t1)
    sb $t4, ($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    addi $t2, $t2, 1
    blt $t2, $t3, copy

    li $s0, 15
    la $s1, matrix
    la $s2, tiles
    la $s3, eq_sol_allocation

    la $t0, found_matches
    li $t1, 16
reset:
    beq $t1, 0, end_reset
    sb $zero, 0($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j reset

end_reset:
randomize:
    addi $a0, $s0, 1
    jal random_ize
    move $t3, $v0

    sll $t4, $s0, 2
    sll $t5, $t3, 2
    add $t6, $s2, $t4
    add $t7, $s2, $t5

    lw $t8, ($t6)
    lw $t9, ($t7)
    sw $t9, ($t6)
    sw $t8, ($t7)

    mul $t4, $s0, 5
    mul $t5, $t3, 5
    add $t6, $s3, $t4
    add $t7, $s3, $t5

    li $t1, 5
expression_swap:
    lb $t8, ($t6)
    lb $t9, ($t7)
    sb $t9, ($t6)
    sb $t8, ($t7)
    addi $t6, $t6, 1
    addi $t7, $t7, 1
    addi $t1, $t1, -1
    bgtz $t1, expression_swap

    addi $s0, $s0, -1
    bgez $s0, randomize

    li $t0, 0
    li $t1, 16
copy_loop:
    sll $t2, $t0, 2
    add $t3, $s2, $t2
    add $t4, $s1, $t2
    lw $t5, ($t3)
    sw $t5, ($t4)

    addi $t0, $t0, 1
    blt $t0, $t1, copy_loop

    sw $zero, matches

    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

match:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    move $s0, $a0
    move $s1, $a1

    la $s2, matrix

    sll $t0, $s0, 2
    sll $t1, $s1, 2
    add $t0, $s2, $t0
    add $t1, $s2, $t1

    lw $s2, ($t0)
    lw $s3, ($t1)

    la $t0, found_matches
    add $t1, $t0, $s0
    add $t2, $t0, $s1
    li $t3, 1
    sb $t3, ($t1)
    sb $t3, ($t2)

    bne $s2, $s3, no_match

    lw $t0, matches
    addi $t0, $t0, 1
    sw $t0, matches

    jal display_matrix

    la $a0, match_good
    li $v0, 4
    syscall

    li $v0, 1
    j match_end

no_match:
    sw $ra, 16($sp)
    jal display_matrix

    li $v0, 32
    li $a0, 1250
    syscall

    la $t0, found_matches
    add $t1, $t0, $s0
    add $t2, $t0, $s1
    sb $zero, ($t1)
    sb $zero, ($t2)
    jal display_matrix

    lw $ra, 16($sp)
    li $v0, 0

match_end:
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

check_end:
    lw $t0, matches
    li $t1, 8
    beq $t0, $t1, end
    li $v0, 0
    jr $ra

end:
    li $v0, 1
    jr $ra
