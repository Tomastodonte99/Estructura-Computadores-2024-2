    .data
        prompt_num:       .asciiz "�Cu�ntos n�meros desea comparar? (m�nimo 3, m�ximo 5): "
        prompt_input:     .asciiz "Ingrese un n�mero: "
        result_msg:       .asciiz "El n�mero menor es: "
        error_msg:        .asciiz "Debe ingresar entre 3 y 5 n�meros.\n"
        newline:          .asciiz "\n"
        numbers:          .word 0, 0, 0, 0, 0  # Espacio para m�ximo 5 n�meros

    .text
    .globl main

main:
    # Pedir al usuario cu�ntos n�meros desea comparar
    li $v0, 4                  # syscall para imprimir string
    la $a0, prompt_num
    syscall

    li $v0, 5                  # syscall para leer entero
    syscall
    move $t0, $v0              # Guardar la cantidad de n�meros en $t0

    # Verificar que el n�mero ingresado est� entre 3 y 5
    li $t1, 3
    blt $t0, $t1, error        # Si el n�mero es menor a 3, error
    li $t1, 5
    bgt $t0, $t1, error        # Si el n�mero es mayor a 5, error

    # Ingresar los n�meros
    li $t2, 0                  # Inicializar el contador de n�meros ingresados
input_loop:
    beq $t2, $t0, find_min     # Si ya ingresamos todos los n�meros, ir a buscar el menor

    # Pedir el siguiente n�mero
    li $v0, 4                  # syscall para imprimir string
    la $a0, prompt_input
    syscall

    li $v0, 5                  # syscall para leer n�mero entero
    syscall
    sll $t3, $t2, 2            # Calcular el offset (tama�o palabra es 4 bytes, por eso sll 2 bits)
    sw $v0, numbers($t3)       # Guardar el n�mero ingresado en el array `numbers`

    addi $t2, $t2, 1           # Incrementar el contador
    j input_loop               # Repetir el ciclo

# Encontrar el n�mero menor
find_min:
    lw $t3, numbers            # Cargar el primer n�mero en $t3 (asumido como el menor)
    li $t2, 1                  # Inicializar �ndice en 1 (empezamos desde el segundo n�mero)

min_loop:
    beq $t2, $t0, print_result # Si ya revisamos todos los n�meros, ir a imprimir el menor

    sll $t4, $t2, 2            # Calcular el offset del siguiente n�mero
    lw $t5, numbers($t4)       # Cargar el siguiente n�mero

    bge $t3, $t5, update_min   # Si el n�mero actual es menor que el guardado, actualizar el m�nimo
    j next_num

update_min:
    move $t3, $t5              # Actualizar el valor m�nimo a $t3

next_num:
    addi $t2, $t2, 1           # Incrementar el �ndice
    j min_loop                 # Repetir el ciclo

# Imprimir el resultado
print_result:
    li $v0, 4                  # syscall para imprimir string
    la $a0, result_msg
    syscall

    move $a0, $t3              # Pasar el valor m�nimo encontrado
    li $v0, 1                  # syscall para imprimir entero
    syscall

    # Imprimir un salto de l�nea
    li $v0, 4
    la $a0, newline
    syscall

    j exit

# Manejo de errores
error:
    li $v0, 4                  # syscall para imprimir string
    la $a0, error_msg
    syscall
    j exit

# Finalizar el programa
exit:
    li $v0, 10                 # syscall para salir
    syscall
