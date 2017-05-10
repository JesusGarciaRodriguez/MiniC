.data

.$str2
	.asciiz "\n"
$str1
	.asciiz "c = "
_c
	.word 0
_b
	.word 0
_a
	.word 0

.text
.globl main
main:
	li $t0, 0
	sw $t0, _a
	li $t0, 0
	sw $t0, _b
	li $t0, 5
	li $t1, 2
	add $t2, $t0, $t1
	li $t0, 2
	sub $t1, $t2, $t0
	sw $t1, _c
$l1:
	la $a0, $str1
	li $v0, 4
	syscall
	lw $t0, _c
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, $str2
	li $v0, 4
	syscall
	lw $t0, _c
	li $t1, 2
	sub $t2, $t0, $t1
	li $t0, 1
	add $t1, $t2, $t0
	sw $t1, _c
	lw $t0, _c
	bnez $t0, $l1
	jr $ra
