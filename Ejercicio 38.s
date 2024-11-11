/*
https://asciinema.org/a/688688

# =========================================
# Programa: Implementar una cola usando un arreglo
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Implementar una cola usando un arreglo
# Codigo en ensamblador y Python
# =========================================

# Programa de ejemplo en Python: Calcula el contenido acumulado en una cola
# utilizando una lista como estructura de datos.

# Datos de ejemplo (cola)
cola = [32145435, 5345, 12345, 6789, 10234]  # Lista que simula la cola con 5 elementos
tamano = len(cola)                           # Tamaño de la cola

# Inicialización del acumulador
acumulador = 0

# Simulación de la acumulación de valores en la cola
for elemento in cola:
    acumulador += elemento

# Imprimir el resultado acumulado
print(f"El contenido de la cola es: {acumulador}")






Ensamblador

*/
/*
 * Programa de ejemplo en ARM64: Calcula el contenido acumulado en una cola
 * utilizando un arreglo como estructura de datos.
 *
 * Entrada: Un arreglo de enteros que representa la cola.
 * Salida: Muestra el contenido acumulado en el registro w0.
 */

.data
cola: .word 32145435, 5345, 12345, 6789, 10234  // Arreglo que simula la cola con 5 elementos
tamano: .word 5                                 // Tamaño de la cola (definido directamente)

msg_cola: .string "El contenido de la cola es: %d\n"  

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar el acumulador y el índice
    mov     w0, #0                    // Acumulador de la suma
    mov     w1, #5                    // Tamaño de la cola
    adrp    x2, cola                  // Dirección base del arreglo que simula la cola
    add     x2, x2, :lo12:cola

loop_cola:
    cbz     w1, fin_cola              // Si el tamaño es 0, terminar el bucle

    ldr     w3, [x2], #4              // Cargar el siguiente elemento de la cola y avanzar la dirección
    add     w0, w0, w3                // Sumar el elemento al acumulador
    sub     w1, w1, #1                // Decrementar el tamaño (contador de elementos)

    b       loop_cola                 // Repetir para el siguiente elemento

fin_cola:
    // Imprimir el resultado acumulado
    adrp    x0, msg_cola              // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_cola
    mov     w1, w0                    // Pasar el contenido acumulado de la cola a w1 para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16       // Restaurar el frame pointer y el link register
    mov     x0, #0                    // Código de salida 0
    ret
