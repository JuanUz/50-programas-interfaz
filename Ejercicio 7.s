/*
https://asciinema.org/a/jOS7fVADpp9xfO0VA1vu7xouS

# =========================================
# Programa: Factorial de un número
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Solicita un número al usuario y calcula su factorial
# Codigo en Python y Ensamblador
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


def int_to_str(num):
    """Convierte un número entero en una cadena de caracteres."""
    if num == 0:
        return "0"
    result = ""
    while num > 0:
        result = chr((num % 10) + ord('0')) + result
        num //= 10
    return result


def factorial(n):
    """Calcula el factorial de un número n."""
    result = 1
    while n > 1:
        result *= n
        n -= 1
    return result


# Programa principal
if __name__ == "__main__":
    # Solicita el número al usuario
    print_str("Ingrese un número para calcular el factorial: ")
    user_input = input()  # Leer entrada del usuario

    # Convertir la entrada a entero
    number = str_to_int(user_input)

    # Calcular el factorial
    factorial_result = factorial(number)

    # Mostrar el resultado
    print_str("El factorial del número es: ")
    print_str(int_to_str(factorial_result))
    print()  # Para nueva línea al final



#Ensamblador

*/

        .section .data
prompt: .asciz "Ingrese un número para calcular el factorial: "
resultado: .asciz "El factorial del número es: "
buffer:   .space 16                 // Espacio para la entrada del usuario y el resultado

        .section .text
        .global _start

_start:
        // Mostrar mensaje para ingresar el número
        ldr x0, =prompt
        bl print_str

        // Leer el número desde la entrada estándar
        mov x0, #0                  // File descriptor 0 (entrada estándar)
        ldr x1, =buffer             // Guardar en buffer
        mov x2, #15                 // Tamaño máximo de entrada
        mov x8, #63                 // Syscall de read
        svc 0

        // Convertir el número leído a entero
        ldr x1, =buffer
        bl str_to_int
        mov x9, x0                  // Guardar el número en x9

        // Calcular el factorial (x9!)
        mov x0, #1                  // Inicializar el resultado en 1
        mov x1, x9                  // Inicializar contador con el valor de x9
factorial_loop:
        cmp x1, #1                  // Verificar si el contador es 1
        ble end_factorial           // Si es <= 1, salir del bucle
        mul x0, x0, x1              // Multiplicar el resultado actual por el contador
        sub x1, x1, #1              // Decrementar el contador
        b factorial_loop            // Repetir el bucle

end_factorial:
        // Convertir el resultado a texto en buffer
        mov x1, x0                  // Pasar el resultado del factorial a x1 para conversión
        ldr x2, =buffer             // Dirección del buffer para el resultado
        bl int_to_str               // Convertir número a texto

        // Imprimir el texto del resultado y el valor convertido
        ldr x0, =resultado          // Mensaje de "El factorial del número es: "
        bl print_str
        ldr x0, =buffer             // Dirección del buffer que contiene el número
        bl print_str

        // Terminar el programa
        mov x8, #93                 // Syscall para "exit"
        svc 0

// =========================================
// Subrutina: str_to_int (Convierte cadena en x1 a entero en x0)
// =========================================
str_to_int:
        mov x0, #0                  // Inicializa el resultado en 0
        mov x2, #10                 // Base decimal
convert_loop:
        ldrb w3, [x1], #1           // Leer siguiente byte de la cadena
        cmp w3, #10                 // Verificar salto de línea (ASCII 10)
        beq end_convert             // Si es salto de línea, termina conversión
        sub w3, w3, #'0'            // Convertir de ASCII a dígito
        mul x0, x0, x2              // Multiplica el resultado actual por 10
        add x0, x0, x3              // Sumar el dígito actual
        b convert_loop
end_convert:
        ret

// =========================================
// Subrutina: int_to_str (Convierte entero en x1 a cadena en x2 e invierte el resultado)
// =========================================
int_to_str:
        mov x3, #10                 // Base decimal
        mov x4, x2                  // Apunta al inicio del buffer
store_digits:
        udiv x5, x1, x3             // Divide x1 entre 10, cociente en x5
        msub x6, x5, x3, x1         // Obtiene el dígito actual
        add x6, x6, #'0'            // Convierte el dígito a ASCII
        strb w6, [x4], #1           // Almacena el dígito en buffer
        mov x1, x5                  // Actualiza x1 con el cociente
        cbnz x1, store_digits       // Repite si x1 no es cero

        // Invertir el buffer para mostrar el número correctamente
        sub x4, x4, x2              // Calcula la longitud de la cadena
        sub x4, x4, #1              // Longitud de la cadena menos uno
        mov x5, x2                  // Apunta al inicio del buffer
reverse:
        ldrb w6, [x5]               // Carga el primer dígito
        ldrb w7, [x2, x4]           // Carga el último dígito
        strb w7, [x5], #1           // Intercambia el primer dígito con el último
        sub x4, x4, #1              // Decrementa x4 manualmente
        strb w6, [x2, x4]           // Almacena el primer dígito en la posición del último
        subs x4, x4, #1             // Ajusta x4 para el siguiente intercambio
        b.ge reverse                // Repite hasta que se complete la inversión
        ret

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                 // Syscall para write
        mov x1, x0                  // Dirección de la cadena a imprimir
        mov x2, #30                 // Longitud máxima del mensaje
        mov x0, #1                  // File descriptor 1 (salida estándar)
        svc 0
        ret


