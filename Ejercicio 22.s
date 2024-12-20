/*
https://asciinema.org/a/688652

# =========================================
# Programa: Conversión de ASCII a entero
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Conversión de ASCII a entero
# Codigo en ensamblador y Python
# =========================================


# Programa en Python para convertir una cadena ASCII de dígitos en un número entero

# Cadena de entrada
ascii_str = "12345"

def ascii_to_int(ascii_str):
    result = 0  # Inicializar el acumulador de resultado

    # Recorrer cada carácter en la cadena
    for char in ascii_str:
        # Convertir el carácter ASCII a su valor numérico restando '0'
        digit = ord(char) - ord('0')
        
        # Multiplicar el acumulador por 10 y sumar el nuevo dígito
        result = result * 10 + digit

    return result

# Realizar la conversión
integer_result = ascii_to_int(ascii_str)

# Imprimir el resultado
print(f"Resultado de la conversión: {integer_result}")






*/


.data
    // Cadena de dígitos ASCII de entrada
    ascii_str:   .string "12345"

    // Variable para almacenar el número entero resultante
    result:      .quad   0

    // Mensajes para imprimir
    msg:         .string "Resultado de la conversión: "
    format:      .string "%ld\n"       // Formato para imprimir el número entero

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Preparar parámetros para conversión de ASCII a entero
    adrp    x0, ascii_str
    add     x0, x0, :lo12:ascii_str
    adrp    x1, result
    add     x1, x1, :lo12:result
    bl      ascii_to_int

    // Imprimir mensaje de resultado
    adrp    x0, msg
    add     x0, x0, :lo12:msg
    bl      printf

    // Imprimir número entero convertido
    ldr     x1, [x1]                   // Cargar valor del resultado
    adrp    x0, format
    add     x0, x0, :lo12:format
    bl      printf

    // Restaurar stack y salir
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para convertir cadena ASCII a entero
// Entrada: x0 = dirección de la cadena ASCII
//          x1 = dirección de la variable de resultado
ascii_to_int:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    mov     x2, #0                    // Inicializar acumulador de resultado

loop:
    ldrb    w3, [x0], #1              // Cargar siguiente byte de la cadena y avanzar
    cmp     w3, #0                    // ¿Es el final de la cadena?
    beq     end_conversion            // Si es cero, fin de la conversión

    sub     w3, w3, #'0'              // Convertir ASCII a valor numérico

    // Multiplicar el acumulador por 10 usando desplazamientos y sumas
    lsl     x2, x2, #3                // Multiplicar por 8 (x2 * 8)
    add     x2, x2, x2, lsl #1        // Multiplicar por 10 (8 + 2)
    
    add     x2, x2, x3                // Sumar el dígito al acumulador

    b       loop                      // Repetir con el siguiente carácter

end_conversion:
    str     x2, [x1]                  // Guardar resultado en la variable destino
    ldp     x29, x30, [sp], #16
    ret
