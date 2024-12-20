/*
https://asciinema.org/a/688666

# =========================================
# Programa: Establecer, borrar y alternar bits
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Establecer, borrar y alternar bits
# Codigo en ensamblador y Python
# =========================================

# Definir la cadena de entrada
cadena = "Example"

# Inicializar los resultados
resultado_establecer = 0     # Resultado para establecer bits
resultado_borrar = 0xFF      # Resultado para borrar bits (todos los bits en 1)
resultado_alternar = 0       # Resultado para alternar bits

# Recorrer cada carácter de la cadena y aplicar las operaciones de bits
for char in cadena:
    valor = ord(char)  # Convertir el carácter a su valor ASCII

    # Establecer bits usando OR (|=)
    resultado_establecer |= valor

    # Borrar bits usando AND con complemento (~)
    resultado_borrar &= ~valor

    # Alternar bits usando XOR (^=)
    resultado_alternar ^= valor

# Imprimir los resultados
print(f"Bits establecidos: {resultado_establecer}")
print(f"Bits borrados: {resultado_borrar}")
print(f"Bits alternados: {resultado_alternar}")






Ensamblador
*/



/*
 * Realiza la operación de establecer, borrar y alternar bits en una cadena.
 *
 * Entrada: Una cadena de caracteres ASCII (terminada en NULL).
 * Salida: Resultado de establecer, borrar y alternar bits.
 */

.data
    cadena:             .string "Example"                  // Cadena de ejemplo
    msg_set_bits:       .string "Bits establecidos: %d\n"   // Mensaje para imprimir bits establecidos
    msg_clear_bits:     .string "Bits borrados: %d\n"       // Mensaje para imprimir bits borrados
    msg_toggle_bits:    .string "Bits alternados: %d\n"     // Mensaje para imprimir bits alternados

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

    // Llamar a la función que establece, borra y alterna bits
    bl      modificar_bits

    // Imprimir el resultado de establecer bits
    mov     w1, w2                          // Pasar el resultado de establecer bits a w1 para printf
    adrp    x0, msg_set_bits
    add     x0, x0, :lo12:msg_set_bits       // Primer parámetro (mensaje) para printf
    bl      printf

    // Imprimir el resultado de borrar bits
    mov     w1, w3                          // Pasar el resultado de borrar bits a w1 para printf
    adrp    x0, msg_clear_bits
    add     x0, x0, :lo12:msg_clear_bits     // Primer parámetro (mensaje) para printf
    bl      printf

    // Imprimir el resultado de alternar bits
    mov     w1, w4                          // Pasar el resultado de alternar bits a w1 para printf
    adrp    x0, msg_toggle_bits
    add     x0, x0, :lo12:msg_toggle_bits    // Primer parámetro (mensaje) para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función modificar_bits
// Entrada: x0 = dirección de la cadena
// Salida: w2 = resultado de establecer bits, w3 = resultado de borrar bits, w4 = resultado de alternar bits
modificar_bits:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar resultados
    mov     w2, #0        // Resultado de establecer bits inicializado a 0
    mov     w3, #0xFF     // Resultado de borrar bits inicializado a 0xFF (todos los bits en 1)
    mov     w4, #0        // Resultado de alternar bits inicializado a 0

loop:
    ldrb    w1, [x0], #1         // Leer un byte de la cadena y avanzar el puntero
    cbz     w1, fin              // Si es NULL (fin de cadena), salir

    // Establecer bits: ORR para fijar bits en 1
    orr     w2, w2, w1           // OR bit a bit para establecer bits

    // Borrar bits: AND con el complemento para borrar bits
    bic     w3, w3, w1           // BIC borra bits específicos (w3 AND NOT w1)

    // Alternar bits: EOR para alternar bits
    eor     w4, w4, w1           // XOR bit a bit para alternar bits

    b       loop

fin:
    ldp     x29, x30, [sp], #16
    ret
