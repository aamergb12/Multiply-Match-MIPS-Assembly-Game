.text
	.globl random_ize
	
random_ize:

    	addi $sp, $sp, -4
    	sw $ra, ($sp)
    
    	li $v0, 42
    	move $a1, $a0
    	li $a0, 0
    	syscall
    
    	move $v0, $a0
    
    	lw $ra, ($sp)
    	addi $sp, $sp, 4
    	jr $ra
    
