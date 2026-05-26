.data
movermsg: .asciiz "Mover disco "
demsg:	.asciiz " de "
amsg:	.asciiz " a "
line:	.asciiz "\n"

.text

main:

	#inicializar parametros
	li $a0,3				#$a0: n=3	
	li $a1,1				#%a1: origen
	li $a2,2				#%a2:auxiliar
	li $a3,3				#%a3: destino

	jal hanoi

	li $v0, 10             # Terminar programa
    syscall
#end main

hanoi:								#hanoi(n,origen,auxiliar,destino)
	#take space on stack
	addi $sp, $sp, -20				#5 spaces on stack
	sw $ra, 0($sp) 
	sw $a0, 4($sp) 
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)

	#base case
	addi $t0, $zero, 1
	beq	$a0, $t0, baseCase			#if $a0 == 1 then baseCase

	
	#swap parameters
	addi $a0, $a0, -1				#n-1
	move $t0, $a3
	move $a3, $a2
	move $a2, $t0
	jal hanoi						#hanoi(n-1,origen,destino,auxiliar)
	
	#move disk OJOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO Xd
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	jal move_disk 					# print move disk

	#swap parameters
	addi $a0, $a0, -1				#n-1	
	move $t0, $a1
	move $a1, $a2
	move $a2, $t0
	jal hanoi					#hanoi(n-1,auxiliar,origen,destino)

	#restore memory on stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 20

	#exit or return
	jr $ra						#jump to $ra
#end hanoi


baseCase:
	#move disk
	jal move_disk				# print move disk

	#restore memory on stack
	lw $ra, 0($sp)				
	lw $a0, 4($sp)				# n
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 20				
	
	jr $ra
#end baseCase

move_disk:

	add $t0, $zero, $a0
	add $t1, $zero, $a1
	add $t3, $zero, $a3

	li $v0, 4				#codigo de servicio para mostrar strings
	la $a0, movermsg 
	syscall

	li $v0, 1 				#codigo de servicio para imprimir un entero
	move $a0, $t0
	syscall

	li $v0, 4				#codigo de servicio para mostrar strings
	la $a0, demsg 
	syscall

	li $v0, 1 				#codigo de servicio para imprimir un entero
	move $a0, $t1
	syscall

	li $v0, 4				#codigo de servicio para mostrar strings
	la $a0, amsg 
	syscall

	li $v0, 1 				#codigo de servicio para imprimir un entero
	move $a0, $t3
	syscall

	li $v0, 4				#codigo de servicio para mostrar strings
	la $a0, line 
	syscall

	add $a0, $zero, $t0
	jr $ra					# jump  $ra
#end move_disk
