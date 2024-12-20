/*
https://asciinema.org/a/688664

# =========================================
# Programa: 	Desplazamientos a la izquierda y derecha
# Autor: Garcia Ornelas Juan Carlos
# Descripción: 	Desplazamientos a la izquierda y derecha
# Codigo en ensamblador y Python
# =========================================

# Definir la cadena de entrada
cadena = "Example"

# Recorrer cada carácter de la cadena y aplicar desplazamientos
for char in cadena:
    valor = ord(char)  # Convertir el carácter a su valor ASCII
    desplazamiento_izq = valor << 1  # Desplazamiento a la izquierda en 1 bit
    desplazamiento_der = valor >> 1  # Desplazamiento a la derecha en 1 bit

    # Imprimir los resultados para cada carácter
    print(f"Carácter: '{char}' (ASCII: {valor})")
    print(f"Desplazamiento a la izquierda: {desplazamiento_izq}")
    print(f"Desplazamiento a la derecha: {desplazamiento_der}")
    print()  # Línea en blanco para separar resultados






Ensamblador
*/

/*
 * Realiza desplazamientos a la izquierda y a la derecha en una cadena.
 *
 * Entrada: Una cadena de caracteres ASCII (terminada en NULL).
 * Salida: Resultado de los desplazamientos a la izquierda y a la derecha.
 */

.data
    cadena:           .string "Example"              // Cadena de ejemplo
    msg_shift_left:   .string "Desplazamiento Izq: %d\n" // Mensaje para imprimir desplazamiento a la izquierda
    msg_shift_right:  .string "Desplazamiento Der: %d\n" // Mensaje para imprimir desplazamiento a la derecha

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

    // Llamar a la función que realiza desplazamientos
    bl      desplazamientos

    // Imprimir el resultado del desplazamiento a la izquierda
    mov     w1, w2                       // Pasar el resultado del desplazamiento a w1 para printf
    adrp    x0, msg_shift_left
    add     x0, x0, :lo12:msg_shift_left // Primer parámetro (mensaje) para printf
    bl      printf

    // Imprimir el resultado del desplazamiento a la derecha
    mov     w1, w3                       // Pasar el resultado del desplazamiento a w1 para printf
    adrp    x0, msg_shift_right
    add     x0, x0, :lo12:msg_shift_right // Primer parámetro (mensaje) para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función desplazamientos
// Entrada: x0 = dirección de la cadena
// Salida: w2 = resultado de desplazamiento a la izquierda, w3 = resultado de desplazamiento a la derecha
desplazamientos:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar resultados
    mov     w2, #0       // Resultado del desplazamiento a la izquierda inicializado a 0
    mov     w3, #0       // Resultado del desplazamiento a la derecha inicializado a 0

loop:
    ldrb    w1, [x0], #1         // Leer un byte de la cadena y avanzar el puntero
    cbz     w1, fin              // Si es NULL (fin de cadena), salir

    lsl     w2, w1, #1           // Desplazamiento a la izquierda en 1 bit
    lsr     w3, w1, #1           // Desplazamiento a la derecha en 1 bit
    b       loop

fin:
    ldp     x29, x30, [sp], #16
    ret

