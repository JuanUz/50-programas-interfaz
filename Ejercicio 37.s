/*
https://asciinema.org/a/688687

# =========================================
# Programa: Implementar una pila usando un arreglo
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Implementar una pila usando un arreglo
# Codigo en ensamblador y Python
# =========================================

# Programa de ejemplo en Python: Calcula el contenido acumulado en una pila
# utilizando una lista como estructura de datos.

# Datos de ejemplo
pila = [32145435, 5345, 12345, 6789, 10234]  # Arreglo que simula la pila con 5 elementos
tamano = len(pila)                           # Tamaño de la pila

# Inicialización del acumulador
acumulador = 0

# Simulación de la acumulación de valores en la pila
for elemento in pila:
    acumulador += elemento

# Imprimir el resultado acumulado
print(f"El contenido de la pila es: {acumulador}")






Ensamblador
*/

/*
 * Programa de ejemplo en ARM64: Calcula el contenido acumulado en una pila
 * utilizando un arreglo como estructura de datos.
 *
 * Entrada: Un arreglo de enteros que representa la pila.
 * Salida: Muestra el contenido acumulado en el registro w0.
 */

.data
pila: .word 32145435, 5345, 12345, 6789, 10234  // Arreglo que simula la pila con 5 elementos
tamano: .word 5                                 // Tamaño del arreglo (definido directamente)

msg_pila: .string "El contenido de la pila es: %d\n"  

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar el acumulador y el índice
    mov     w0, #0                    // Acumulador de la suma
    mov     w1, #5                    // Tamaño de la pila
    adrp    x2, pila                  // Dirección base del arreglo que simula la pila
    add     x2, x2, :lo12:pila

loop_pila:
    cbz     w1, fin_pila              // Si el tamaño es 0, terminar el bucle

    ldr     w3, [x2], #4              // Cargar un elemento de 4 bytes y avanzar la dirección
    add     w0, w0, w3                // Sumar el elemento al acumulador
    sub     w1, w1, #1                // Decrementar el tamaño (contador de elementos)

    b       loop_pila                 // Repetir para el siguiente elemento

fin_pila:
    // Imprimir el resultado acumulado
    adrp    x0, msg_pila              // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_pila
    mov     w1, w0                    // Pasar el contenido acumulado de la pila a w1 para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16       // Restaurar el frame pointer y el link register
    mov     x0, #0                    // Código de salida 0
    ret

