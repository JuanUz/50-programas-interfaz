/*
https://asciinema.org/a/aVEL9KtDdkBVMSMlhpyRenEB5

# =========================================
# Programa: Convertir decimal a binario
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Convertir decimal a binario
# Codigo en ensamblador y Python
# =========================================


# Programa en Python: Convierte un número decimal a binario
# Entrada: Número decimal en la variable `num_decimal`
# Salida: Imprime la representación binaria del número en la consola

# Número decimal de ejemplo
num_decimal = 29

# Inicialización de variables
binario = ""  # Cadena para almacenar la representación binaria
num_bits = 32  # Para manejar hasta 32 bits (ajustable según el tamaño requerido)

# Conversión de decimal a binario
for i in range(num_bits - 1, -1, -1):  # Procesa cada bit desde el más significativo
    # Desplazar el número y aplicar máscara para obtener el bit
    bit = (num_decimal >> i) & 1
    # Concatenar el bit convertido a carácter ('0' o '1') a la cadena binaria
    binario += str(bit)

# Imprimir el resultado
print(f"El binario es: {binario}")









Ensamblador

*/

/*
 * Programa en ARM64: Convierte un número decimal a binario
 *
 * Entrada: Número decimal en la variable `num_decimal`.
 * Salida: Imprime la representación binaria del número en la consola.
 */

.data
num_decimal: .word 29                      // Número decimal de ejemplo (29 en este caso)
msg_binario: .string "El binario es: %s\n" // Mensaje de salida
binario: .space 33                         // Cadena para almacenar el binario (32 bits + nulo)

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar el número decimal
    adrp    x0, num_decimal               // Cargar la base de la dirección de 'num_decimal'
    add     x0, x0, :lo12:num_decimal     // Completa la dirección de 'num_decimal'
    ldr     w1, [x0]                      // Cargar el valor decimal en w1

    // Inicialización
    adrp    x2, binario                   // Cargar la base de la dirección de 'binario'
    add     x2, x2, :lo12:binario         // Completa la dirección de 'binario'
    mov     w3, #32                       // Contador para 32 bits

loop_conversion:
    subs    w3, w3, #1                    // Decrementa el contador de bits
    lsr     w4, w1, w3                    // Desplaza el número a la derecha
    and     w4, w4, #1                    // Aisla el bit menos significativo
    add     w4, w4, '0'                   // Convierte el bit en carácter ASCII ('0' o '1')
    strb    w4, [x2], #1                  // Almacena el carácter en la cadena y avanza el puntero

    cbnz    w3, loop_conversion           // Repite hasta procesar los 32 bits

    // Terminar la cadena con un nulo
    mov     w4, #0                        // Terminador nulo
    strb    w4, [x2]

    // Imprimir el resultado
    adrp    x0, msg_binario               // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_binario
    adrp    x1, binario                   // Cargar la dirección base de 'binario' para printf
    add     x1, x1, :lo12:binario
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16           // Restaurar el frame pointer y el link register
    mov     x0, #0                        // Código de salida 0
    ret
