.data

.$str8
	.asciiz "\n"
$str7
	.asciiz "Final"
$str6
	.asciiz "\n"
$str5
	.asciiz "c = "
$str4
	.asciiz "No a y b\n"
$str3
	.asciiz "\n"
$str2
	.asciiz "a"
$str1
	.asciiz "Inicio del programa\n"
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
	la $a0, $str1
	li $v0, 4
	syscall
	lw $t0, _a
	beqz $t0, $l5
	la $a0, $str2
	li $v0, 4
	syscall
	la $a0, $str3
	li $v0, 4
	syscall
	b $l6
	$l5:
	lw $t1, _b
	beqz $t1, $l3
	la $a0, $str4
	li $v0, 4
	syscall
	b $l4
	$l3:
	$l1:
	lw $t2, _c
	beqz $t2, $l2
	la $a0, $str5
	li $v0, 4
	syscall
	lw $t3, _c
	move $a0, $t3
	li $v0, 1
	syscall
	la $a0, $str6
	li $v0, 4
	syscall
	lw $t3, _c
	li $t4, 2
	sub $t5, $t3, $t4
	li $t3, 1
	add $t4, $t5, $t3
	sw $t4, _c
	b $l1
	$l2:
	$l4:
	$l6:
	la $a0, $str7
	li $v0, 4
	syscall
	la $a0, $str8
	li $v0, 4
	syscall
	jr $ra
