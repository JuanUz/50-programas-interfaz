/*
https://asciinema.org/a/688667

# =========================================
# Programa: Contar los bits activados en un número
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Contar los bits activados en un número
# Codigo en ensamblador y Python
# =========================================

# Definir la cadena de entrada
cadena = "Example"

# Inicializar el contador de bits activados
contador_bits_activos = 0

# Recorrer cada carácter de la cadena y contar los bits activados
for char in cadena:
    valor = ord(char)  # Convertir el carácter a su valor ASCII

    # Contar los bits activados en el valor actual
    while valor > 0:
        contador_bits_activos += valor & 1  # Sumar 1 si el bit menos significativo es 1
        valor >>= 1  # Desplazar a la derecha para procesar el siguiente bit

# Imprimir el número total de bits activados
print(f"Bits activados: {contador_bits_activos}")







Ensamblador
*/

/*
 * Cuenta los bits activados (en 1) en cada carácter de una cadena.
 *
 * Entrada: Una cadena de caracteres ASCII (terminada en NULL).
 * Salida: Número total de bits activados en la cadena.
 */

.data
    cadena:             .string "Example"                // Cadena de ejemplo
    msg_bits_activos:   .string "Bits activados: %d\n"   // Mensaje para imprimir el total de bits activados

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

    // Llamar a la función que cuenta los bits activados
    bl      contar_bits_activados

    // Imprimir el número total de bits activados
    mov     w1, w2                          // Pasar el resultado a w1 para printf
    adrp    x0, msg_bits_activos
    add     x0, x0, :lo12:msg_bits_activos   // Primer parámetro (mensaje) para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función contar_bits_activados
// Entrada: x0 = dirección de la cadena
// Salida: w2 = número total de bits activados
contar_bits_activados:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    mov     w2, #0          // Inicializar el contador de bits activados a 0

loop:
    ldrb    w1, [x0], #1    // Leer un byte de la cadena y avanzar el puntero
    cbz     w1, fin         // Si es NULL (fin de cadena), salir

    // Contar los bits activados en w1
cuenta_bits:
    tst     w1, #1          // Probar el bit menos significativo
    cset    w3, ne          // Si es 1, establecer w3 en 1
    add     w2, w2, w3      // Sumar el resultado al contador
    lsr     w1, w1, #1      // Desplazar w1 a la derecha
    cbnz    w1, cuenta_bits // Repetir mientras w1 no sea 0

    b       loop

fin:
    ldp     x29, x30, [sp], #16
    ret
