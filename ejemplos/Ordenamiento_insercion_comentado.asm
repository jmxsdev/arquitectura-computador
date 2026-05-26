.data
	vector: .word 5,4,3,2,1
	n: .word 5
	blanco: .asciiz " "           # Espacio para separar los números al imprimir
    	newline: .asciiz "\n"        # Salto de línea
.text
	main:
	la $s0, vector
	lw $s1, n
	
	jal insertion
	
	la $a0, vector
	lw $a1, n
	
	jal recorrer_vector
	
	li $v0, 10
	syscall

	insertion:
	add $sp, $sp, -12		# Reservacion de pila y sus valores
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	li $t0, 1			# Inicializo i = 1
	move $s3, $s0			# Cargo el vector en la posicion 0 en $s1
	addi $s3, $s3, 4		# Aumento la posicion del vector v[i] -> v[i+1]

	
	for:
	beq $t0, $s1, end_insertion	# Si $t0 == $s1 entonces salta a end_insertion ( i == n )
	lw $t1, 0($s3)			# $t1 = v[i] equivalente a key = v[i]
	addi $t2, $t0, -1		# j = i - 1
	sll $t3, $t2, 2			# $t3 = $t2 * 4
	add $s4, $s0, $t3		# Cargo la direccion para v[j] con la direccion del vector mas la posicion
	lw $t3, 0($s4)			# $t3 = v[j] le paso el elemento que esta en esa posicion
	
	while:
	bltz $t2, exit_while		# Condicion contraria de j>=0: j<0
	ble $t3, $t1, exit_while	# Condicion contraria de v[j]>key: v[j]<=key	
					# Se hace de esta manera para simular un AND logico en caso de que alguno de los dos
					# no se cumpla se sale del while
	sw $t3, 4($s4) 			# v[j+1] = v[j]
	addi $t2, $t2, -1		# j = j - 1
	addi $s4, $s4, -4		# Muevo el vector v[j} -> v[j-1]
	lw $t3, 0($s4)			# Actualizo el valor de v[j] para el siguiente
	j while
	
	exit_while:
	sw $t1, 4($s4)			# v[j+1] = key
	addi $t0, $t0, 1		# Aumenta i = i + 1
	addi $s3, $s3, 4		# Mueve la direccion del vector v[i] -> v[i+1]
	j for

	end_insertion:			# Desapila y devuele valores 
	lw $s0, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	add $sp, $sp, 12
	jr $ra				# Retorno
	
#################################################################################################################################################
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

#void insertionSort(int arr[], int n) {
#    int i, key, j;
#
#    for (i = 1; i < n; i++) {
#        key = arr[i];
#        j = i - 1;
#        while (j >= 0 && arr[j] > key) {
#            arr[j + 1] = arr[j];
#            j = j - 1;
#        }
#        arr[j + 1] = key;
#    }
#}
