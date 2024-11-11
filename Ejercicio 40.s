/*
https://asciinema.org/a/688708

# =========================================
# Programa: Convertir binario a decimal
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Convertir binario a decimal
# Codigo en ensamblador y Python
# =========================================


def binario_a_decimal(binario):
    decimal = 0
    for caracter in binario:
        decimal = decimal * 2 + int(caracter)  # Desplazar y agregar el bit
    return decimal

# Cadena binaria de ejemplo
binario = "11101"  # Esto representa 29 en decimal

# Convertir de binario a decimal
decimal = binario_a_decimal(binario)

# Imprimir el resultado
print(f"El decimal es: {decimal}")






Ensamblador
*/

/*
 * Programa en ARM64: Convierte una cadena binaria a decimal
 *
 * Entrada: Cadena de caracteres que representa un número binario.
 * Salida: Imprime el valor decimal del número en la consola.
 */

.data
binario: .string "11101"                 // Cadena binaria de ejemplo (11101 en binario es 29 en decimal)
msg_decimal: .string "El decimal es: %d\n" // Mensaje de salida

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar el acumulador de decimal
    mov     w0, #0                       // Acumulador decimal inicializado a 0

    // Cargar la dirección de la cadena binaria
    adrp    x1, binario
    add     x1, x1, :lo12:binario

conversion_loop:
    ldrb    w2, [x1], #1                 // Cargar el siguiente carácter de la cadena y avanzar el puntero
    cbz     w2, fin_conversion           // Si el carácter es nulo ('\0'), fin de la conversión

    sub     w2, w2, '0'                  // Convertir el carácter '0' o '1' a valor numérico (0 o 1)
    lsl     w0, w0, #1                   // Desplazar el acumulador una posición a la izquierda
    orr     w0, w0, w2                   // Agregar el bit al acumulador

    b       conversion_loop              // Repetir el ciclo para el siguiente bit

fin_conversion:
    // Imprimir el resultado
    adrp    x0, msg_decimal              // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_decimal
    mov     w1, w0                       // Pasar el valor decimal a w1 como argumento para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16          // Restaurar el frame pointer y el link register
    mov     x0, #0                       // Código de salida 0
    ret
