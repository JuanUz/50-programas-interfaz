/*
https://asciinema.org/a/687702

// =========================================
// Programa: Suma de dos números con entrada
// Autor: Garcia Ornelas Juan Carlos.
// Descripción: Solicita dos números al usuario, los suma y muestra el resultado en consola
// =========================================

//Python

# =========================================
# Programa: Suma de dos números con entrada
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Solicita dos números al usuario, los suma y muestra el resultado en consola
# =========================================

def str_to_int(string):
    # Convertir cadena a entero
    try:
        return int(string.strip())
    except ValueError:
        print("Error: Por favor, ingrese un número válido.")
        return None

def int_to_str(number):
    # Convertir entero a cadena
    return str(number)

def main():
    # Solicitar el primer número
    num1_str = input("Ingrese el primer número: ")
    num1 = str_to_int(num1_str)
    
    if num1 is None:
        return  # Salir si el primer número no es válido
    
    # Solicitar el segundo número
    num2_str = input("Ingrese el segundo número: ")
    num2 = str_to_int(num2_str)
    
    if num2 is None:
        return  # Salir si el segundo número no es válido

    # Sumar los dos números
    resultado = num1 + num2

    # Mostrar el resultado
    print("Resultado de la suma:", int_to_str(resultado))

if __name__ == "__main__":
    main()


Ensamblador
*/

        .section .data
prompt1: .asciz "Ingrese el primer número: "
prompt2: .asciz "Ingrese el segundo número: "
resultado: .asciz "Resultado de la suma: "
buffer:   .space 16                 // Espacio para almacenar la entrada del usuario y el resultado

        .section .text
        .global _start

_start:
        // Mostrar mensaje para el primer número
        ldr x0, =prompt1
        bl print_str

        // Leer el primer número desde la entrada estándar
        mov x0, #0                  // File descriptor 0 (entrada estándar)
        ldr x1, =buffer             // Guardar en buffer
        mov x2, #15                 // Tamaño máximo de entrada (ajustado)
        mov x8, #63                 // Syscall de read
        svc 0

        // Convertir el primer número leído a entero
        ldr x1, =buffer             // Dirección del buffer donde está el número en texto
        bl str_to_int               // Llamada a subrutina para convertir a entero en x0
        mov x9, x0                  // Guardar primer número en x9

        // Mostrar mensaje para el segundo número
        ldr x0, =prompt2
        bl print_str

        // Leer el segundo número desde la entrada estándar
        mov x0, #0                  // File descriptor 0 (entrada estándar)
        ldr x1, =buffer             // Guardar en buffer
        mov x2, #15                 // Tamaño máximo de entrada
        mov x8, #63                 // Syscall de read
        svc 0

        // Convertir el segundo número leído a entero
        ldr x1, =buffer             // Dirección del buffer donde está el número en texto
        bl str_to_int               // Llamada a subrutina para convertir a entero en x0
        add x0, x9, x0              // Sumar primer número (x9) y segundo número (x0)

        // Convertir el resultado a texto en buffer
        mov x1, x0                  // Pasar el resultado de la suma a x1 para conversión
        ldr x2, =buffer             // Dirección del buffer para el resultado
        bl int_to_str               // Convertir número a texto

        // Imprimir el texto del resultado y el valor convertido
        ldr x0, =resultado          // Mensaje de "Resultado de la suma: "
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
// Subrutina: int_to_str (Convierte entero en x1 a cadena en x2)
// =========================================
int_to_str:
        mov x3, #10
        mov x4, x2
conv_loop:
        udiv x5, x1, x3
        msub x6, x5, x3, x1
        add x6, x6, #'0'
        strb w6, [x4], #1
        mov x1, x5
        cbnz x1, conv_loop
        ret

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                 // Syscall para write
        mov x1, x0                  // Dirección de la cadena a imprimir
        mov x2, #25                 // Longitud máxima del mensaje
        mov x0, #1                  // File descriptor 1 (salida estándar)
        svc 0
        ret


