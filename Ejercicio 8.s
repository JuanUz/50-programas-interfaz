/*
https://asciinema.org/a/688574

# =========================================
# Programa: Serie de Fibonacci hasta 200 (Impresión explícita)
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Imprime de forma explícita la serie de Fibonacci hasta 200
# Codigo en python y en ensamblador
# =========================================

def print_str(message):
    """Imprime un mensaje en la consola."""
    print(message, end='')

# Programa principal
if __name__ == "__main__":
    # Mensaje inicial
    mensaje = "La serie de Fibonacci hasta 200 es:\n"
    fibonacci_seq = "0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144\n"

    # Imprimir mensaje y secuencia de Fibonacci
    print_str(mensaje)
    print_str(fibonacci_seq)





Ensamblador
*/

.section .data
mensaje: .asciz "La serie de Fibonacci hasta 200 es:\n"
fibonacci_seq: .asciz "0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144\n"

        .section .text
        .global _start

_start:
        // Mostrar el mensaje de inicio de la serie
        ldr x0, =mensaje
        bl print_str

        // Imprimir la secuencia de Fibonacci explícita
        ldr x0, =fibonacci_seq
        bl print_str

        // Terminar el programa
        mov x8, #93                 // Syscall para "exit"
        svc 0

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                 // Syscall para write
        mov x1, x0                  // Dirección de la cadena a imprimir
        mov x2, #100                // Longitud máxima del mensaje (ajusta según tu cadena)
        mov x0, #1                  // File descriptor 1 (salida estándar)
        svc 0
        ret
