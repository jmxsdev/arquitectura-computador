.data
array: .word 64, 25, 12, 22, 11, 90, 33, 45, 78, 5, 100, 3, 67, 88, 42
size: .word 15
temp: .space 60
msg_original: .asciiz "Array original: "
msg_ordenado: .asciiz "\nArray ordenado (Merge Sort): "
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
    
    # Llamar a merge_sort
    la $a0, array
    li $a1, 0                # left
    lw $a2, size
    addi $a2, $a2, -1        # right
    jal merge_sort
    
    # Imprimir array ordenado
    la $a0, msg_ordenado
    li $v0, 4
    syscall
    
    la $a0, array
    lw $a1, size
    jal print_array
    
    li $v0, 10
    syscall

print_array:
    move $t0, $a0
    li $t1, 0
print_loop:
    bge $t1, $a1, print_end
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    li $a0, ' '
    li $v0, 11
    syscall
    addi $t0, $t0, 4
    addi $t1, $t1, 1
    j print_loop
print_end:
    li $a0, '\n'
    li $v0, 11
    syscall
    jr $ra

# merge_sort(array, left, right)
merge_sort:
    addi $sp, $sp, -32
    sw $ra, 28($sp)
    sw $s0, 24($sp)
    sw $s1, 20($sp)
    sw $s2, 16($sp)
    sw $s3, 12($sp)
    sw $s4, 8($sp)
    
    move $s0, $a0    # array
    move $s1, $a1    # left
    move $s2, $a2    # right
    
    # if left < right
    bge $s1, $s2, merge_sort_end
    
    # Calcular mid = (left + right) / 2
    add $s3, $s1, $s2
    sra $s3, $s3, 1      # $s3 = mid
    
    # Ordenar izquierda: merge_sort(array, left, mid)
    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    jal merge_sort
    
    # Ordenar derecha: merge_sort(array, mid+1, right)
    move $a0, $s0
    addi $a1, $s3, 1
    move $a2, $s2
    jal merge_sort
    
    # Mezclar: merge(array, left, mid, right)
    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    move $a3, $s2
    jal merge
    
merge_sort_end:
    lw $ra, 28($sp)
    lw $s0, 24($sp)
    lw $s1, 20($sp)
    lw $s2, 16($sp)
    lw $s3, 12($sp)
    lw $s4, 8($sp)
    addi $sp, $sp, 32
    jr $ra

# merge(array, left, mid, right)
merge:
    addi $sp, $sp, -40
    sw $ra, 36($sp)
    sw $s0, 32($sp)
    sw $s1, 28($sp)
    sw $s2, 24($sp)
    sw $s3, 20($sp)
    sw $s4, 16($sp)
    sw $s5, 12($sp)
    sw $s6, 8($sp)
    sw $s7, 4($sp)
    
    move $s0, $a0    # array
    move $s1, $a1    # left
    move $s2, $a2    # mid
    move $s3, $a3    # right
    
    # Calcular tamaños
    sub $t0, $s2, $s1
    addi $t0, $t0, 1        # n1 = mid - left + 1
    sub $t1, $s3, $s2       # n2 = right - mid
    
    # Usar temp global
    la $s4, temp            # $s4 = temp buffer
    
    # Copiar izquierda a temp
    move $t2, $s1           # i = left
    move $t3, $s4           # puntero temp
    li $t4, 0               # contador
copy_left_temp:
    bge $t4, $t0, copy_right_temp
    sll $t5, $t2, 2
    add $t5, $s0, $t5
    lw $t6, 0($t5)
    sw $t6, 0($t3)
    addi $t2, $t2, 1
    addi $t3, $t3, 4
    addi $t4, $t4, 1
    j copy_left_temp
    
copy_right_temp:
    # Copiar derecha a temp (después de izquierda)
    addi $t2, $s2, 1        # j = mid + 1
    move $t3, $s4
    sll $t5, $t0, 2
    add $t3, $t3, $t5       # temp + n1
    li $t4, 0               # contador
copy_right_temp_loop:
    bge $t4, $t1, merge_arrays_start
    sll $t5, $t2, 2
    add $t5, $s0, $t5
    lw $t6, 0($t5)
    sw $t6, 0($t3)
    addi $t2, $t2, 1
    addi $t3, $t3, 4
    addi $t4, $t4, 1
    j copy_right_temp_loop

merge_arrays_start:
    # Índices para mezclar
    move $t2, $s4            # puntero izquierda (temp)
    move $t3, $s4
    sll $t4, $t0, 2
    add $t3, $t3, $t4       # puntero derecha (temp + n1)
    move $t4, $s1            # k = left
    li $t5, 0                # i = 0
    li $t6, 0                # j = 0
    
merge_loop_new:
    # Si i >= n1, copiar resto derecha
    bge $t5, $t0, copy_rest_derecha
    # Si j >= n2, copiar resto izquierda
    bge $t6, $t1, copy_rest_izquierda
    
    # Obtener valores
    sll $t7, $t5, 2
    add $t7, $t2, $t7
    lw $t8, 0($t7)          # left[i]
    
    sll $t7, $t6, 2
    add $t7, $t3, $t7
    lw $t9, 0($t7)          # right[j]
    
    # Comparar
    ble $t8, $t9, take_left_new
    
    # Tomar de derecha
    sll $t7, $t4, 2
    add $t7, $s0, $t7
    sw $t9, 0($t7)
    addi $t6, $t6, 1        # j++
    j increment_k_new
    
take_left_new:
    # Tomar de izquierda
    sll $t7, $t4, 2
    add $t7, $s0, $t7
    sw $t8, 0($t7)
    addi $t5, $t5, 1        # i++
    
increment_k_new:
    addi $t4, $t4, 1        # k++
    j merge_loop_new

copy_rest_izquierda:
    bge $t5, $t0, merge_end_new
    sll $t7, $t5, 2
    add $t7, $t2, $t7
    lw $t8, 0($t7)
    sll $t7, $t4, 2
    add $t7, $s0, $t7
    sw $t8, 0($t7)
    addi $t5, $t5, 1
    addi $t4, $t4, 1
    j copy_rest_izquierda

copy_rest_derecha:
    bge $t6, $t1, merge_end_new
    sll $t7, $t6, 2
    add $t7, $t3, $t7
    lw $t9, 0($t7)
    sll $t7, $t4, 2
    add $t7, $s0, $t7
    sw $t9, 0($t7)
    addi $t6, $t6, 1
    addi $t4, $t4, 1
    j copy_rest_derecha

merge_end_new:
    lw $ra, 36($sp)
    lw $s0, 32($sp)
    lw $s1, 28($sp)
    lw $s2, 24($sp)
    lw $s3, 20($sp)
    lw $s4, 16($sp)
    lw $s5, 12($sp)
    lw $s6, 8($sp)
    lw $s7, 4($sp)
    addi $sp, $sp, 40
    jr $ra