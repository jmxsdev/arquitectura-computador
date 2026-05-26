.data
array: .word 64, 25, 12, 22, 11, 90, 33, 45, 78, 5, 100, 3, 67, 88, 42
size: .word 15
msg_original: .asciiz "Array original: "
msg_ordenado: .asciiz "\nArray ordenado (Selection Sort): "
space: .asciiz " "

.text
main:
    # Imprimir array original
    la $a0, msg_original
    li $v0, 4
    syscall
    
    la $a0, array
    lw $a1, size
    jal print_array
    
    # Llamar a selection sort
    la $a0, array
    lw $a1, size
    jal selection_sort
    
    # Imprimir array ordenado
    la $a0, msg_ordenado
    li $v0, 4
    syscall
    
    la $a0, array
    lw $a1, size
    jal print_array
    
    # Salir
    li $v0, 10
    syscall

# Función para imprimir el array
# $a0 = dirección del array, $a1 = tamaño
print_array:
    move $t0, $a0           # dirección actual
    li $t1, 0               # contador
    li $t2, 0               # índice
print_loop:
    bge $t2, $a1, print_end
    lw $a0, 0($t0)          # cargar valor
    li $v0, 1               # imprimir entero
    syscall
    li $a0, ' '             # imprimir espacio
    li $v0, 11
    syscall
    addi $t0, $t0, 4        # siguiente elemento
    addi $t2, $t2, 1        # incrementar índice
    j print_loop
print_end:
    li $a0, '\n'            # salto de línea
    li $v0, 11
    syscall
    jr $ra

# selection_sort(array, size)
# $a0 = dirección del array, $a1 = tamaño
selection_sort:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    move $s0, $a0           # $s0 = array
    move $s1, $a1           # $s1 = tamaño
    
    # for (i = 0; i < size-1; i++)
    li $t0, 0               # i = 0
    addi $t1, $s1, -1       # size-1
    
outer_loop:
    bge $t0, $t1, sort_end  # si i >= size-1, terminar
    
    # min_idx = i
    move $t2, $t0           # $t2 = min_idx
    
    # for (j = i+1; j < size; j++)
    addi $t3, $t0, 1        # j = i+1
    
inner_loop:
    bge $t3, $s1, swap      # si j >= size, intercambiar
    
    # Obtener array[min_idx] y array[j]
    sll $t4, $t2, 2         # offset de min_idx
    add $t4, $s0, $t4
    lw $t5, 0($t4)          # $t5 = array[min_idx]
    
    sll $t6, $t3, 2         # offset de j
    add $t6, $s0, $t6
    lw $t7, 0($t6)          # $t7 = array[j]
    
    # if array[j] < array[min_idx]
    bge $t7, $t5, next      # si array[j] >= array[min_idx], saltar
    
    # min_idx = j
    move $t2, $t3
    
next:
    addi $t3, $t3, 1        # j++
    j inner_loop
    
swap:
    # Intercambiar array[i] y array[min_idx]
    # if i == min_idx, no intercambiar
    beq $t0, $t2, next_i
    
    # Obtener direcciones
    sll $t4, $t0, 2         # offset de i
    add $t4, $s0, $t4
    lw $t5, 0($t4)          # $t5 = array[i]
    
    sll $t6, $t2, 2         # offset de min_idx
    add $t6, $s0, $t6
    lw $t7, 0($t6)          # $t7 = array[min_idx]
    
    # Intercambiar
    sw $t7, 0($t4)          # array[i] = array[min_idx]
    sw $t5, 0($t6)          # array[min_idx] = array[i]
    
next_i:
    addi $t0, $t0, 1        # i++
    j outer_loop
    
sort_end:
    lw $ra, 12($sp)
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra