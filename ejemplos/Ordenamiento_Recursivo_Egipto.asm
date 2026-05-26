.data
	vector: .word 5,4,3,2,1
	i: 	.word 0
	mov: 	.word 1
	tam: 	.word 5
	blanco: .asciiz " "           # Espacio para separar los números al imprimir
    	newline: .asciiz "\n"        # Salto de línea
	
.text
	main:
	la $a0, vector
	lw $a1, i
	lw $a2, mov
	lw $a3, tam
	
	jal egipto
	
	la $a0, vector
	lw $a1, tam
	
	jal recorrer_vector
	
	end:
	li $v0, 10
	syscall
	
	egipto:
	addi $sp, $sp, -20
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	sw $ra, 0($sp)
	
	if_1:				# Si alguna de las 2 no es verdad entonces no entra hacer la recursion
	bge $a1, $a3, end_egipto	# i >= tam Cond. Contraria de i < tam
	bgt $a2, $a3, end_egipto	# mov > tam Cond. Contraria de mov <= tam
	
	# Se procede hacer carga de los vectores v[i] y v[mov]
	move $s0, $a0			# Preservamos la direccion del vector en $s0
	sll $t0, $a1, 2			
	add $t0, $s0, $t0		# Cargamos la direccion del vector vec[i]
	sll $t1, $a2, 2
	add $t1, $s0, $t1		# Cargamos la direccion del vector vec[mov]
	
	if_2:
	blt $a2, $a3, else		# mov < tam Cond. Contraria de mov >= tam
	addi $a1, $a1, 1		# i = i + 1
	addi $a2, $a1, 1		# mov = i + 2. OJO:EL ADDi ES CON + 1 YA QUE EL REGISTRO DE LA I A SIDO AUMENTADO EN LA LINEA ANT.
	jal egipto			# Llama a la funcion recursiva
	j end_egipto			# Salta al fin cuando retorna la recursion
	
	else:
	lw $t2,0($t0)			# $t2 = vec[i} 
	lw $t3,0($t1)			# $t3 = vec[mov]
	
	if_3:
	ble $t2, $t3, no_swap		# vec[i] <= vec[mov] Cond. Contraria de vec[i] > vec[mov]	
	
	swap:
	sw $t2, 0($t1)			# vec[mov] = $t2
	sw $t3, 0($t0)			# vec[i]   = $t3
	
	no_swap:
	addi $a2, $a2, 1		# mov = mov + 1
	jal egipto			# Llama a la funcion recursiva
	
	end_egipto:
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra
	
	
	recorrer_vector:			# Necesito hacer una reservacion de pila
	addi $sp, $sp, -12
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
		
	move $t0, $a0			# MUEVO EL VECTOR A T0
	move $t1, $a1			# MUEVO EL TAM_VEC A T1
		
	for_recorrer:
	beq $t1, $zero, exit_for_recorrer    # Se puede usar tambien beqz $t1, exit_for
		
	lw $a0, 0($t0)		    	# LW PARA PASAR EL NUMERO QUE ESTA EN EL VECTOR EN LA POSICION I ( VECTOR[I])
	li $v0,1			# MUESTRO POR PANTALLA EL NUMERO
	syscall				# MOSTRAR
		
	li $v0,4			# HACE UN SALTO DE LINEA
	la $a0, blanco	
	syscall
		
	subi $t1, $t1, 1		# T1 = T1 - 1
	addi $t0, $t0, 4		# I = I + 1   (AVANZA UN ESPACIO HACIA DELANTE EN EL VECTOR PASA DE VEC[I] A VEC[I+1] 
	j for_recorrer				# SALTA A LA ETIQUETA FOR PARA QUE SE VUELVA A REPETIR
	
	exit_for_recorrer:
	lw $a0, 8($sp)			# HACE LA DEVOLUCION DE LA PILA
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra				# LLAMA AL QUE LO LLAMÓ
		
	sl:
	li $v0, 4
	la $a0, blanco
	syscall
	jr $ra
	
