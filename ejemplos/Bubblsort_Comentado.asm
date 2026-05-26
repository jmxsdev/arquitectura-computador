.data 
	array: .word 5,4,3,2,1,10,9,99,0	# Vector de enteros
	size: .word 9				# Tamaño del arreglo
	msg1: .asciiz "El vector ordenado es: "
	blanco: .asciiz " "
	
################################################################################################################################################

.text
	main:
	la $a0, array			# Cargo el arreglo en $a0
	lw $a1, size			# Cargo el valor del tamaño del arrelgo en $a1
	
	jal bubblesort			# Llamada a la funcion bubblesort
	jal mostrar_vector		# Llamada a la funcion para mostrar el vector
	
	end:				# Etiqueta para señalar el fin del programa
	li $v0, 10			
	syscall				# FIN DEL PROGRAMA
	
################################################################################################################################################
	
	bubblesort:			# Funcion bubblesort
	addi $sp, $sp, -12		# Se hace la reservacion de pila y todos los valores a utilizar
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	move $s0, $a0			# Carga del arreglo $s0 = $a0	
	addi $t0, $a1, -1		# size = size - 1    ( $t0 = $a1 - 1)
	li $t1, 0			# i = 0
	
	for_1:				# Primer Ciclo
	beq $t1, $t0, return_stack	# Si i = size - 1 entonces salta a return_stack
	sub $t2, $t0, $t1		# size(for2) = size -i -1 
	li $t3, 0			# j = 0		# Reinicia el contador de j a 0
	
	for_2:
	beq $t3, $t2, next_for_1	# Si j = size -i -1 entonces salta a next_for_1
	lw $t4, 0($s0)			# $t4 = array[j] 
	lw $t5, 4($s0)			# $t5 = array[j+1]
	slt $t6, $t5, $t4		# Si $t4 < $t5 entonces $t6 = 1 sino $t6 = 0
	beq $t6,$zero, no_swap		# Si $t6 == 0 entonces salta a No_Swap
	
	swap:				# Intercambio entre array[j] y array [j+1]
	sw $t5, 0($s0)
	sw $t4, 4($s0)
	
	no_swap:
	addi $t3, $t3, 1		# j = j+1
	addi $s0, $s0, 4		# Mueve la direccion del vector a la siguiente array[j] -> array[j+1]
	
	j for_2				# Salta a for_2
	
	next_for_1:			# Para cuando el for_2 se acaba entra acá 
	addi $t1, $t1, 1		# i = i+1
	la $s0, array			# Se reinicia la direccion del vector para que comience desde su primera posicion
	j for_1				# Salta a for_1

	return_stack:			# Retorna la direccion de la pila y sus valores
	lw $a0, 8($sp)
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, -12
	
	jr $ra				# Se devuelve a donde fue llamada la funcion
	
########################################################################################################################################################
	
	mostrar_vector:			# Esto no lo voy a comentar ya ustedes deben saber xd 
	
	la $s0, array
	lw $s1, size
	
	li $v0, 4
	la $a0, msg1
	syscall
	
	while:
	beqz $s1, exit_while
	
	li $v0,1
	lw $a0, 0($s0)
	syscall
	
	li $v0, 4
	la $a0, blanco
	syscall
	
	addi $s0, $s0, 4
	addi $s1, $s1, -1
	
	j while
	
	exit_while:
	jr $ra
	
#####################################################################################################################################	
#	FUNCION ESCRITA EN C Y LLEVADA A MIPS 32
#
#
#void bubblesort(int array[], int size){
#    int temp;
#    for (int i = 0; i < size - 1; i++){
#        for (int j = 0; j < size-i-1; j++){
#            if (array[j] > array[j+1]){
#                //intercambiar elementos
#                temp = array[j];
#                array[j] = array[j+1];
#                array[j+1] = temp;
#            }
#        }
#    }
#}
