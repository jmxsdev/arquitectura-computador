.data
	factorial: .word 15

.text 
	main:
	lw $a0,factorial		# Paso el valor de factorial al registro $a0
	add $v0, $v0, 1			# Inicializo la variable $v0 en 1 para poder hacer correctamente la multiplicacion del resultado de salida
	jal Factos			# Llamo a la funcion recursiva factos 
	
	move $a0,$v0			# El resultado lo muevo de $v0 a $a0
	li $v0,1			# Aviso al sistema que va imprimir un valor entero
	syscall				# Imprime
	
	li $v0, 10			# Sale del programa
	syscall
	
	Factos:				# Funcion recursiva factos
	addi $sp, $sp, -8		# Hacemos la reservacion de pila
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	beqz $a0, fin_recursion		# Si $a0 es igual a 0 entonces se acaba la recursion y salta a la etiqueta fin_recursion
	
	mul $v0, $v0, $a0		# Hace la multiplicacion del valor de $v0 que esta inicializado en 1 la primera vez y se multiplica con el valor actual de $a0
	sub $a0, $a0, 1			# Luego decrementa el valor 
	jal Factos			# Llama a la funcion recursiva
	
	fin_recursion:			# Etiqueta de fin de recursion
	lw $ra, 4($sp)			# Devuelve los valores de pila
	lw $a0, 0($sp)
	addi $sp, $sp, 8		
	jr $ra
