/*
https://asciinema.org/a/688657

# =========================================
# Programa: Calcular la longitud de una cadena
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Calcular la longitud de una cadena
# Codigo en ensamblador y Python
# =========================================

# Calcula la longitud de una cadena de números
def longitud_cadena(cadena):
    contador = 0
    
    for caracter in cadena:
        if caracter == '\0':  # Detectar fin de cadena (NULL)
            break
        contador += 1
    
    return contador

# Cadena de números de ejemplo
cadena = "1234567890\0"  # Nota: el '\0' indica el final de la cadena en estilo C

# Llamar a la función y mostrar el resultado
longitud = longitud_cadena(cadena)
print(f"Longitud de la cadena: {longitud}")










Ensamblador

*/

/* 
 * Calcula la longitud de una cadena de números.
 * 
 * Entrada: Una cadena de caracteres ASCII con números (terminada en NULL).
 * Salida: Longitud de la cadena en caracteres.
 */

.data
    cadena:     .string "1234567890"     // Cadena de ejemplo de números
    msg_result: .string "Longitud de la cadena: %d\n" // Mensaje para imprimir
    formato:    .string "%s"

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
    
    // Llamar a la función que calcula la longitud
    bl      longitud_cadena

    // Imprimir el resultado
    mov     x1, x0                     // Transferir la longitud al segundo parámetro de printf
    adrp    x0, msg_result
    add     x0, x0, :lo12:msg_result   // Primer parámetro (mensaje) para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función longitud_cadena
// Entrada: x0 = dirección de la cadena a medir
// Salida:  x0 = longitud de la cadena
longitud_cadena:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar contador de longitud
    mov     x1, #0      // x1 será nuestro contador de longitud

loop:
    ldrb    w2, [x0, x1]    // Leer un byte de la cadena
    cbz     w2, fin         // Si es NULL (fin de cadena), salir
    add     x1, x1, #1      // Incrementar contador
    b       loop            // Repetir el bucle

fin:
    mov     x0, x1          // Mover longitud a x0 como resultado

    ldp     x29, x30, [sp], #16
    ret
