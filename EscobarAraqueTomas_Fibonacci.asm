    .data
        prompt_fib:      .asciiz "�Cu�ntos n�meros de la serie Fibonacci desea generar?: "
        result_msg:      .asciiz "\nLa serie Fibonacci es: "
        sum_msg:         .asciiz "\nLa suma de los n�meros de la serie es: "
        newline:         .asciiz "\n"
    
    .text
    .globl main

main:
    # Pedir al usuario cu�ntos n�meros de Fibonacci desea generar
    li $v0, 4                  # syscall para imprimir string
    la $a0, prompt_fib
    syscall

    li $v0, 5                  # syscall para leer entero
    syscall
    move $t0, $v0              # Guardar el n�mero de t�rminos solicitados en $t0

    # Inicializar primeros dos t�rminos de Fibonacci
    li $t1, 0                  # fib(0)
    li $t2, 1                  # fib(1)
    li $t3, 0                  # �ndice de la serie
    move $t4, $t1              # Inicializar suma con fib(0)
    add $t4, $t4, $t2          # Sumar fib(0) + fib(1)

    # Imprimir mensaje de resultado
    li $v0, 4                  # syscall para imprimir string
    la $a0, result_msg
    syscall

    # Imprimir el primer n�mero (fib(0))
    move $a0, $t1              # Pasar fib(0) para imprimir
    li $v0, 1                  # syscall para imprimir entero
    syscall

    # Imprimir un salto de l�nea
    li $v0, 4
    la $a0, newline
    syscall

    # Si solo quiere un n�mero, terminamos aqu�
    beq $t0, 1, print_sum      # Si solo pidi� un n�mero, ir a imprimir la suma

    # Imprimir el segundo n�mero (fib(1))
    move $a0, $t2              # Pasar fib(1) para imprimir
    li $v0, 1                  # syscall para imprimir entero
    syscall

    # Imprimir un salto de l�nea
    li $v0, 4
    la $a0, newline
    syscall

    # Generar la serie Fibonacci desde el tercer t�rmino en adelante
fib_loop:
    addi $t3, $t3, 1           # Incrementar el �ndice de la serie
    beq $t3, $t0, print_sum    # Si ya generamos todos los t�rminos solicitados, ir a imprimir la suma

    # fib(n) = fib(n-1) + fib(n-2)
    add $t5, $t1, $t2          # Calcular el siguiente n�mero de Fibonacci (fib(n-2) + fib(n-1))
    
    # Imprimir el siguiente n�mero de Fibonacci
    move $a0, $t5              # Pasar fib(n) para imprimir
    li $v0, 1                  # syscall para imprimir entero
    syscall

    # Imprimir un salto de l�nea
    li $v0, 4
    la $a0, newline
    syscall

    # Actualizar para el siguiente t�rmino
    move $t1, $t2              # fib(n-2) = fib(n-1)
    move $t2, $t5              # fib(n-1) = fib(n)
    
    # Sumar el nuevo n�mero a la suma total
    add $t4, $t4, $t5

    j fib_loop                 # Repetir el proceso

# Imprimir la suma de la serie
print_sum:
    li $v0, 4                  # syscall para imprimir string
    la $a0, sum_msg
    syscall

    move $a0, $t4              # Pasar la suma total de la serie
    li $v0, 1                  # syscall para imprimir entero
    syscall

    # Imprimir un salto de l�nea
    li $v0, 4
    la $a0, newline
    syscall

    j exit                     # Salir del programa

# Finalizar el programa
exit:
    li $v0, 10                 # syscall para salir
    syscall
