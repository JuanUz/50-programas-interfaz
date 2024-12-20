/*
https://asciinema.org/a/688681

# =========================================
# Programa: Invertir los elementos de un arreglo
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Invertir los elementos de un arreglo
# Codigo en ensamblador y Python
# =========================================

# Arreglo de ejemplo con 5 elementos
arreglo = [32145435, 5345, 12345, 6789, 10234]

def invertir_arreglo(arr):
    # Inicializar índices para inversión
    inicio = 0
    fin = len(arr) - 1

    # Bucle para invertir los elementos del arreglo
    while inicio < fin:
        # Intercambiar elementos en posiciones 'inicio' y 'fin'
        arr[inicio], arr[fin] = arr[fin], arr[inicio]

        # Avanzar el índice de inicio y retroceder el índice de fin
        inicio += 1
        fin -= 1

# Llamar a la función para invertir el arreglo
invertir_arreglo(arreglo)

# Imprimir el arreglo invertido
print("El arreglo invertido es:")
for elemento in arreglo:
    print(elemento)







Ensamblador
*/

/*
 * Invierte los elementos de un arreglo de enteros y los imprime en consola.
 *
 * Entrada: Un arreglo de enteros.
 * Salida: Arreglo invertido e impreso en la consola.
 */

.data
arreglo: .word 32145435, 5345, 12345, 6789, 10234  // Arreglo de ejemplo con 5 elementos
tamano: .word 5                                    // Tamaño del arreglo
msg_elemento: .string "%d\n"                       // Formato para imprimir cada elemento

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!   // Guardar el frame pointer y el link register
    mov     x29, sp

    // Preparar variables para el proceso de inversión
    mov     w1, #5                  // Tamaño del arreglo (5 elementos)
    sub     w1, w1, #1              // Índice del último elemento
    mov     w0, #0                  // Índice del primer elemento
    adrp    x2, arreglo             // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo

loop_invertir:
    cmp     w0, w1                  // Comparar índices
    b.ge    fin_invertir            // Si los índices se cruzan o son iguales, terminar

    ldr     w3, [x2, w0, sxtw #2]   // Cargar elemento en posición w0
    ldr     w4, [x2, w1, sxtw #2]   // Cargar elemento en posición w1

    str     w4, [x2, w0, sxtw #2]   // Colocar elemento de w1 en w0
    str     w3, [x2, w1, sxtw #2]   // Colocar elemento de w0 en w1

    add     w0, w0, #1              // Avanzar índice inicial
    sub     w1, w1, #1              // Retroceder índice final

    b       loop_invertir            // Repetir para el siguiente par

fin_invertir:
    // Imprimir el arreglo invertido
    mov     w0, #0                  // Reiniciar índice para impresión
    mov     w1, #5                  // Reiniciar el tamaño del arreglo
    adrp    x2, arreglo             // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo

loop_imprimir:
    cbz     w1, fin_programa        // Si no quedan elementos, terminar

    ldr     w3, [x2], #4            // Cargar elemento y avanzar dirección del arreglo
    adrp    x0, msg_elemento        // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_elemento
    mov     w1, w3                  // Colocar el elemento en w1 para printf
    bl      printf                  // Llamar a printf para imprimir el elemento

    sub     w1, w1, #1              // Decrementar el contador de elementos
    b       loop_imprimir           // Repetir para el siguiente elemento

fin_programa:
    // Epílogo de la función main
    ldp     x29, x30, [sp], #16     // Restaurar el frame pointer y el link register
    mov     x0, #0                  // Código de salida 0
    ret
