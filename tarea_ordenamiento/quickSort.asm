.data
array: .word 64, 25, 12, 22, 11, 90, 33, 45, 78, 5
size: .word 10
msg_ordenado: .asciiz "\nArray ordenado: "
space: .asciiz " "

.text
main:
    la $a0, array        # dirección base del array
    lw $a1, size         # tamaño del array
    addi $a1, $a1, -1    # último índice = size-1
    
    # Llamar a quicksort(array, 0, size-1)
    li $a2, 0            # límite inferior
    jal quicksort
    
    # Imprimir resultado
    la $a0, msg_ordenado
    li $v0, 4
    syscall
    
    la $t0, array
    lw $t1, size
    li $t2, 0
print_loop:
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    
    li $a0, ' '
    li $v0, 11
    syscall
    
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    blt $t2, $t1, print_loop
    
    li $v0, 10
    syscall

quicksort:
    # $a0 = array, $a1 = low, $a2 = high
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    
    bge $a1, $a2, return  # if low >= high: return
    
    # Llamar a partition
    jal partition
    # $v0 = posición del pivote
    move $s0, $v0
    
    # Guardar low y high antes de llamadas recursivas
    move $s1, $a1          # guardar low original
    move $t0, $a2          # guardar high original
    
    # Ordenar lado izquierdo: quicksort(array, low, pivot-1)
    addi $a2, $s0, -1      # high = pivot-1
    jal quicksort
    
    # Ordenar lado derecho: quicksort(array, pivot+1, high)
    move $a1, $s0
    addi $a1, $a1, 1       # low = pivot+1
    move $a2, $t0          # high = high original
    jal quicksort
    
return:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

partition:
    # $a0 = array, $a1 = low, $a2 = high
    # Retorna: $v0 = posición del pivote
    
    # Elegir pivote = array[high]
    sll $t0, $a2, 2        # offset high
    add $t0, $a0, $t0
    lw $t1, 0($t0)         # pivote
    move $t2, $a1          # i = low - 1
    addi $t2, $t2, -1
    
    move $t3, $a1          # j = low
partition_loop:
    bgt $t3, $a2, end_partition
    
    # Calcular array[j]
    sll $t4, $t3, 2
    add $t4, $a0, $t4
    lw $t5, 0($t4)
    
    bgt $t5, $t1, partition_increment  # if array[j] > pivote: saltar
    
    # i++
    addi $t2, $t2, 1
    
    # Intercambiar array[i] y array[j]
    sll $t6, $t2, 2
    add $t6, $a0, $t6
    lw $t7, 0($t6)
    lw $t8, 0($t4)
    sw $t8, 0($t6)
    sw $t7, 0($t4)
    
partition_increment:
    addi $t3, $t3, 1
    j partition_loop

end_partition:
    # Intercambiar array[i+1] y array[high]
    addi $t2, $t2, 1
    sll $t6, $t2, 2
    add $t6, $a0, $t6
    lw $t7, 0($t6)
    sll $t4, $a2, 2
    add $t4, $a0, $t4
    lw $t5, 0($t4)
    sw $t5, 0($t6)
    sw $t7, 0($t4)
    
    move $v0, $t2          # retornar i+1
    jr $ra
