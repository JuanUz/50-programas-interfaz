/*
https://asciinema.org/a/Lzjs88OO1Uh9DtIxdIwdjPuMX

# =========================================
# Programa: Verificación de número primo
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Solicita un número al usuario y verifica si es primo, mostrando el resultado en consola
# Codigo en Python y en ensamblador
# =========================================

def print_str(message):
    """Imprime un mensaje en la consola."""
    print(message, end='')

def str_to_int(input_str):
    """Convierte una cadena de caracteres en un número entero."""
    result = 0
    for char in input_str.strip():
        if char.isdigit():
            result = result * 10 + int(char)
    return result

def es_primo(n):
    """Verifica si un número es primo.
       Retorna True si es primo, de lo contrario False."""
    if n < 2:
        return False
    if n == 2:
        return True
    divisor = 2
    while divisor * divisor <= n:
        if n % divisor == 0:
            return False
        divisor += 1
    return True

# Programa principal
if __name__ == "__main__":
    # Mensaje de solicitud
    prompt = "Ingrese un número para verificar si es primo: "
    mensaje_primo = "El número es primo.\n"
    mensaje_no_primo = "El número no es primo.\n"

    # Solicita el número al usuario
    print_str(prompt)
    user_input = input()  # Leer entrada del usuario

    # Convertir la entrada a entero
    numero = str_to_int(user_input)

    # Verificar si el número es primo
    if es_primo(numero):
        print_str(mensaje_primo)
    else:
        print_str(mensaje_no_primo)











Ensamblador
*/



.section .data
prompt:           .asciz "Ingrese un número para verificar si es primo: "
mensaje_primo:    .asciz "El número es primo.\n"
mensaje_no_primo: .asciz "El número no es primo.\n"
buffer:           .space 16                  // Espacio para almacenar la entrada del usuario

        .section .text
        .global _start

_start:
        // Mostrar el mensaje de solicitud de número
        ldr x0, =prompt
        bl print_str

        // Leer el número ingresado
        mov x0, #0                    // File descriptor 0 (entrada estándar)
        ldr x1, =buffer               // Guardar en buffer
        mov x2, #15                   // Tamaño máximo de entrada
        mov x8, #63                   // Syscall de read
        svc 0

        // Convertir el número leído a entero
        ldr x1, =buffer               // Dirección del buffer con el número en texto
        bl str_to_int                 // Llamada a subrutina para convertir a entero en x0
        mov x9, x0                    // Guardar número en x9

        // Verificar si el número es primo
        bl es_primo                   // Llamada a la subrutina para verificar primo (resultado en x0)

        // Mostrar el resultado basado en el valor en x0
        cmp x0, #1                    // Comparar resultado de es_primo
        beq es_primo_mensaje          // Si es primo, saltar a imprimir mensaje de primo
        b no_primo_mensaje            // Si no es primo, saltar a imprimir mensaje de no primo

es_primo_mensaje:
        ldr x0, =mensaje_primo
        bl print_str
        b fin                         // Saltar a fin para evitar que continúe a no_primo_mensaje

no_primo_mensaje:
        ldr x0, =mensaje_no_primo
        bl print_str
        b fin                         // Saltar a fin

fin:
        // Terminar el programa
        mov x8, #93                  // Syscall para "exit"
        svc 0

// =========================================
// Subrutina: es_primo (Verifica si el número en x9 es primo, retorna 1 si es primo, 0 si no)
// =========================================
es_primo:
        // Manejar casos especiales (0 y 1 no son primos)
        mov x0, #0                    // Asumimos que no es primo
        cmp x9, #2
        blt no_es_primo               // Si x9 < 2, no es primo
        cmp x9, #2
        beq es_primo_fin              // Si x9 == 2, es primo (caso especial)

        // Caso general
        mov x1, #2                    // Inicializamos divisor en 2
        mov x0, #1                    // Asumimos que es primo (x0 = 1)

verificar_divisor:
        mul x2, x1, x1                // Calculamos x1 * x1
        cmp x2, x9                    // Si x1 * x1 > x9, terminamos la verificación
        b.gt es_primo_fin

        // Verificar si x9 es divisible por x1
        udiv x2, x9, x1               // x2 = x9 / x1
        msub x2, x2, x1, x9           // x2 = x9 - (x2 * x1)
        cbz x2, no_es_primo           // Si el residuo es 0, no es primo

        // Incrementar divisor y continuar
        add x1, x1, #1
        b verificar_divisor

no_es_primo:
        mov x0, #0                    // No es primo
        ret

es_primo_fin:
        ret

// =========================================
// Subrutina: str_to_int (Convierte cadena en x1 a entero en x0)
// =========================================
str_to_int:
        mov x0, #0                    // Inicializa el resultado en 0
        mov x2, #10                   // Base decimal
convert_loop:
        ldrb w3, [x1], #1             // Leer siguiente byte de la cadena
        cmp w3, #10                   // Verificar salto de línea (ASCII 10)
        beq end_convert               // Si es salto de línea, termina conversión
        sub w3, w3, #'0'              // Convertir de ASCII a dígito
        mul x0, x0, x2                // Multiplica el resultado actual por 10
        add x0, x0, x3                // Sumar el dígito actual
        b convert_loop
end_convert:
        ret

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                   // Syscall para write
        mov x1, x0                    // Dirección de la cadena a imprimir
        mov x2, #50                   // Longitud máxima del mensaje
        mov x0, #1                    // File descriptor 1 (salida estándar)
        svc 0
        ret

