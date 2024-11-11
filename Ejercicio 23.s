/*
https://asciinema.org/a/TZou9mfai5UYuneH9Qyehp3fr

# =========================================
# Programa: Conversión de entero a ASCII
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Conversión de entero a ASCII
# Codigo en ensamblador y Python
# =========================================

# Programa en Python para convertir un número entero en una cadena ASCII

def int_to_ascii(number):
    # Caso especial para el número 0
    if number == 0:
        return "0"
    
    result = []  # Lista para almacenar caracteres individuales
    while number > 0:
        # Obtener el dígito menos significativo
        digit = number % 10
        # Convertir el dígito en su representación ASCII
        result.append(chr(digit + ord('0')))
        # Actualizar el número dividiéndolo por 10
        number //= 10

    # Invertir la lista para obtener el número en el orden correcto y unir en una cadena
    return ''.join(result[::-1])

# Número de prueba
number = 12345

# Convertir el número a su representación ASCII
ascii_result = int_to_ascii(number)

# Imprimir el resultado
print(f"Número convertido a ASCII: {ascii_result}")









Ensamblador

*/


.data
    // Número entero a convertir
    number:      .quad   12345

    // Cadena donde se almacenará el resultado ASCII
    ascii_str:   .space  20           // Espacio para almacenar el número convertido (máx. 20 caracteres)
    newline:     .string "\n"

    // Mensajes para imprimir
    msg:         .string "Número convertido a ASCII: "
    format:      .string "%s"         // Formato para imprimir la cadena

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Preparar parámetros para la conversión de entero a ASCII
    ldr     x0, =number               // Cargar dirección del número a convertir
    ldr     x0, [x0]                  // Cargar el valor del número
    adrp    x1, ascii_str             // Dirección base para el resultado ASCII
    add     x1, x1, :lo12:ascii_str
    bl      int_to_ascii

    // Imprimir mensaje de resultado
    adrp    x0, msg
    add     x0, x0, :lo12:msg
    bl      printf

    // Imprimir la cadena ASCII resultante
    adrp    x0, ascii_str
    add     x0, x0, :lo12:ascii_str
    adrp    x1, format
    add     x1, x1, :lo12:format
    bl      printf

    // Imprimir nueva línea
    adrp    x0, newline
    add     x0, x0, :lo12:newline
    bl      printf

    // Restaurar stack y salir
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para convertir entero a ASCII
// Entrada: x0 = número a convertir
//          x1 = dirección de la cadena de resultado (se llena al revés y luego se invierte)
int_to_ascii:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Puntero al final de la cadena de destino
    mov     x2, x1

    // Cargar el valor 10 en x5 para usarlo en divisiones y restos
    mov     x5, #10

    // Comprobar si el número es cero
    cmp     x0, #0
    b.eq    zero_case

convert_loop:
    // Obtener el dígito menos significativo
    udiv    x3, x0, x5               // División x0 / 10, resultado en x3
    msub    x4, x3, x5, x0           // Resto: x4 = x0 - (x3 * 10)
    add     x4, x4, #'0'             // Convertir a carácter ASCII
    strb    w4, [x2, #-1]!           // Almacenar el carácter en la cadena y mover el puntero

    // Actualizar x0 al cociente para el siguiente dígito
    mov     x0, x3
    cbnz    x0, convert_loop          // Repetir si x0 no es cero

    b       end_conversion

zero_case:
    // Si el número es cero, escribir '0'
    mov     w4, #'0'
    strb    w4, [x2, #-1]             // Almacenar '0' en la cadena

end_conversion:
    // Invertir la cadena en su lugar
    mov     x3, x2                    // Puntero de inicio de la cadena invertida
    sub     x1, x1, x2                // Calcular longitud de la cadena
    add     x1, x1, x3                // x1 apunta al último carácter de la cadena ASCII

reverse_loop:
    cmp     x3, x1
    b.ge    done_reversing
    ldrb    w4, [x3]
    ldrb    w5, [x1]
    strb    w5, [x3]
    strb    w4, [x1]
    add     x3, x3, #1
    sub     x1, x1, #1
    b       reverse_loop

done_reversing:
    ldp     x29, x30, [sp], #16
    ret
