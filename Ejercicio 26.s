/*
https://asciinema.org/a/688663

# =========================================
# Programa: Operaciones AND, OR, XOR a nivel de bits
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Operaciones AND, OR, XOR a nivel de bits
# Codigo en ensamblador y Python
# =========================================

# Definir la cadena de entrada
cadena = "Example"

# Inicializar los resultados
resultado_and = 0xFF  # Inicializado con todos los bits en 1 (para AND)
resultado_or = 0      # Inicializado con 0 (para OR)
resultado_xor = 0     # Inicializado con 0 (para XOR)

# Recorrer cada carácter de la cadena
for char in cadena:
    valor = ord(char)  # Convertir el carácter a su valor ASCII
    resultado_and &= valor  # AND bit a bit
    resultado_or |= valor   # OR bit a bit
    resultado_xor ^= valor  # XOR bit a bit

# Imprimir los resultados
print(f"Resultado de AND: {resultado_and}")
print(f"Resultado de OR: {resultado_or}")
print(f"Resultado de XOR: {resultado_xor}")






Ensamblador
*/


/*
 * Realiza operaciones AND, OR, XOR a nivel de bits en una cadena.
 *
 * Entrada: Una cadena de caracteres ASCII (terminada en NULL).
 * Salida: Resultado de las operaciones AND, OR, XOR.
 */

.data
    cadena:         .string "Example"            // Cadena de ejemplo
    msg_and:        .string "Resultado de AND: %d\n" // Mensaje para imprimir resultado AND
    msg_or:         .string "Resultado de OR: %d\n"  // Mensaje para imprimir resultado OR
    msg_xor:        .string "Resultado de XOR: %d\n" // Mensaje para imprimir resultado XOR

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar la dirección de la cadena
    adrp    x0, cadena
    add     x0, x0, :lo12:cadena

    // Llamar a la función que realiza operaciones a nivel de bits
    bl      operaciones_bitwise

    // Imprimir el resultado de AND
    mov     w1, w2                       // Pasar el resultado de AND a w1 para printf
    adrp    x0, msg_and
    add     x0, x0, :lo12:msg_and        // Primer parámetro (mensaje) para printf
    bl      printf

    // Imprimir el resultado de OR
    mov     w1, w3                       // Pasar el resultado de OR a w1 para printf
    adrp    x0, msg_or
    add     x0, x0, :lo12:msg_or         // Primer parámetro (mensaje) para printf
    bl      printf

    // Imprimir el resultado de XOR
    mov     w1, w4                       // Pasar el resultado de XOR a w1 para printf
    adrp    x0, msg_xor
    add     x0, x0, :lo12:msg_xor        // Primer parámetro (mensaje) para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función operaciones_bitwise
// Entrada: x0 = dirección de la cadena
// Salida: w2 = resultado de AND, w3 = resultado de OR, w4 = resultado de XOR
operaciones_bitwise:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar resultados
    mov     w2, #0xFF       // Resultado de AND inicializado a 0xFF (todos los bits en 1)
    mov     w3, #0          // Resultado de OR inicializado a 0
    mov     w4, #0          // Resultado de XOR inicializado a 0

loop:
    ldrb    w1, [x0], #1         // Leer un byte de la cadena y avanzar el puntero
    cbz     w1, fin              // Si es NULL (fin de cadena), salir

    and     w2, w2, w1           // AND bit a bit
    orr     w3, w3, w1           // OR bit a bit
    eor     w4, w4, w1           // XOR bit a bit
    b       loop

fin:
    ldp     x29, x30, [sp], #16
    ret
