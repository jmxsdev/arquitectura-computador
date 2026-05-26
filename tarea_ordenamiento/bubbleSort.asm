.data
	arr: .word 5, 2, 9, 1, 5, 8, 0, 2, 3, 10    # Arreglo original
	n:   .word 10                  		    # Tamaño del arreglo

.text
	main:
  # Cargar dirección base del arreglo y tamaño
  la $a0, arr               # $a0 = dirección base del arreglo
	lw $a1, n                 # $a1 = tamaño del arreglo
	jal bubbleSort            # Llamar al procedimiento
	# Imprimir el arreglo ordenado
	la $a0, arr               # $a0 = dirección base del arreglo
	lw $a1, n                 # $a1 = tamaño del arreglo
  
  jal printArray

	j end                     # Finalizar programa

	bubbleSort:
    	addi $sp, $sp, -8         # Guardar $ra y $s0 en la pila
    	sw $ra, 4($sp)
    	sw $s0, 0($sp)

   	move $s0, $a0             # $s0 = base del arreglo
    	addi $a1, $a1, -1         # $a0 = n - 1 (contador externo)

	OuterLoop:
    	move $t0, $a1
    	beqz $t0, ExitBubble      # beq $t0, $zero, ExitBubble     # Si $t0 == 0, salir del bucle

	move $t1, $t0             # $t1 = n - i - 1 (contador interno)

	InnerLoop:
	blez $t1, OuterNext       # Si $t1 <= 0, ir al siguiente i
        lw $t2, 0($s0)            # Cargar arr[j] en $t2
	lw $t3, 4($s0)            # Cargar arr[j + 1] en $t3
	ble $t2, $t3, NoSwap      # Si arr[j] <= arr[j + 1], no intercambiar

    	# Intercambio de arr[j] y arr[j + 1]
    	sw $t2, 4($s0)
    	sw $t3, 0($s0)

        NoSwap:
        addi $s0, $s0, 4          # Incrementar la posición del puntero
        addi $t1, $t1, -1          # Decrementar $t1
        j InnerLoop

	OuterNext:
   	la $s0, arr                # Reiniciar el puntero a la base del arreglo
    	addi $a1, $a1, -1          # Decrementar $t0
   	j OuterLoop

	ExitBubble:
    	lw $ra, 4($sp)            # Restaurar $ra y $s0
	lw $s0, 0($sp)
	addi $sp, $sp, 8
    	jr $ra                    # Retornar

	end:
    	li $v0, 10                # Finalizar programa
    	syscall
################################################################
.data
space: .asciiz " "
msg: .asciiz "arreglo ordenado:\n"

.text
printArray:	#$a0 array, $a1 size
	move $t0, $a0
	move $t1, $a1

	li $v0, 4
	la $a0, msg
	syscall
whilePrint:
	#bge $t0, $a1, exitPrint
	lw $a0, 0($t0)
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, space
	syscall

	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bgtz $t1, whilePrint
	jr $ra
