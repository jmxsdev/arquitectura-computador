.data
arr:        .word   3, -1, 2, -5, 4             # Arreglo original
n:          .word   5                           # Tamaño del arreglo

.text
main:

    la      $a0,        arr
    lw      $a1,        n

    jal     sort

    li      $v0,        10
    syscall


sort:
    addi    $sp,        $sp,        -20         # reserva espacio en la pila para 5 registros
    sw      $ra,        16($sp)                 # guardar $ra en la pila
    sw      $s3,        12($sp)                 # guardar $s3 en la pila
    sw      $s2,        8($sp)                  # guardar $s2 en la pila
    sw      $s1,        4($sp)                  # guardar $s1 en la pila
    sw      $s0,        0($sp)                  # guardar $s0 en la pila

    move    $s2,        $a0                     # copia el parámetro $a0 en $s2 (guardar $a0)
    move    $s3,        $a1                     # copia el parámetro $a1 en $s3 (guardar $a1)
    move    $s0,        $zero                   # i = 0

for1tst:

    slt     $t0,        $s0,        $s3         # reg $t0 = 0 si $s0 v $s3 (i v n)
    beq     $t0,        $zero,      exit1       # ir a exit1 si $s0 v $s3 (i v n)
    addi    $s1,        $s0,        -1          # j = i – 1

for2tst:

    slti    $t0,        $s1,        0           # reg $t0 = 1 si $s1 < 0 (j < 0)
    bne     $t0,        $zero,      exit2       # ir a exit2 si $s1 < 0 (j < 0)
    sll     $t1,        $s1,        2           # reg $t1 = j * 4
    add     $t2,        $s2,        $t1         # reg $t2 = v + (j * 4)
    lw      $t3,        0($t2)                  # reg $t3 = v[j]
    lw      $t4,        4($t2)                  # reg $t4 = v[j + 1]
    slt     $t0,        $t4,        $t3         # reg $t0 = 0 si $t4 v $t3
    beq     $t0,        $zero,      exit2       # ir a exit2 si $t4 v $t3

    move    $a0,        $s2                     # el primer parámetro de intercambio (swap) es v (antiguo $a0)
    move    $a1,        $s1                     # el segundo parámetro de intercambio (swap) es j
    jal     swap                                # swap código mostrado en la figura 2.25
    addi    $s1,        $s1,        -1          # j -= 1
    j       for2tst                             # salta al test del lazo interior

exit2:
    addi    $s0,        $s0,        1           # i += 1
    j       for1tst                             # salta al test del lazo exterior

exit1:

    lw      $s0,        0($sp)                  # recupera $s0 de la pila
    lw      $s1,        4($sp)                  # recupera $s1 de la pila
    lw      $s2,        8($sp)                  # recupera $s2 de la pila
    lw      $s3,        12($sp)                 # recupera $s3 de la pila
    lw      $ra,        16($sp)                 # recupera $ra de la pila
    addi    $sp,        $sp,        20          # recupera el puntero de la pila

    jr      $ra                                 # retorno a la rutina llamadora

swap:
    sll     $t1,        $a1,        2           # reg $t1 = k * 4
    add     $t1,        $a0,        $t1         # reg $t1 = v + (k * 4)
    # reg $t1 t1 tiene la dirección de v[k]
    lw      $t0,        0($t1)                  # reg $t0 (temp) = v[k]
    lw      $t2,        4($t1)                  # reg $t2 = v[k + 1]
    # referencia al siguiente elemento de v
    sw      $t2,        0($t1)                  # v[k] = reg $t2
    sw      $t0,        4($t1)                  # v[k+1] = reg $t0 (temp)
    jr      $ra                                 # retorna a la rutina que lo llamó