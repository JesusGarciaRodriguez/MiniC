.data
_a: .word 0
_b: .word 0
.text
.globl main
main:
	li $t0,2
	sw $t0,_a
	li $t0,3
	lw $t1,_a
	mul $t2,$t0,$t1
	sw $t2,_b
