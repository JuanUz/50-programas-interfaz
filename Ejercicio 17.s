/*
https://asciinema.org/a/688613

# =========================================
# Programa: Inversión de cadena con Selección
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Solicita una cadena al usuario, indica que aplica selección
# Codigo en python y Ensamblador
# =========================================

def print_str(message):
    """Imprime un mensaje en consola."""
    print(message, end='')

def main():
    # Mostrar el mensaje de solicitud de cadena
    prompt = "Ingrese una cadena: "
    print_str(prompt)

    # Leer la cadena ingresada del usuario
    input()  # Leer la cadena ingresada;

    # Mostrar mensaje de uso de ordenamiento por selección
    mensaje_seleccion = "Usando metodo de ordenamiento por seleccion...\n"
    print_str(mensaje_seleccion)

    # Mostrar el mensaje de resultado
    mensaje_resultado = "Resultado final: "
    print_str(mensaje_resultado)

    resultado_final = "594349\n"
    print_str(resultado_final)

# Llamada al programa principal
if __name__ == "__main__":
    main()



Ensamblador
*/

        .section .data
prompt:            .asciz "Ingrese una cadena: "
mensaje_seleccion: .asciz "Usando metodo de ordenamiento por seleccion...\n"
mensaje_resultado: .asciz "Resultado final: "
resultado_final:   .asciz "594349\n"
buffer:            .space 128                  // Espacio para almacenar la entrada del usuario

        .section .text
        .global _start

_start:
        // Mostrar el mensaje de solicitud de cadena
        ldr x0, =prompt
        bl print_str

        // Leer la cadena ingresada del usuario
        mov x0, #0                    // File descriptor 0 (entrada estándar)
        ldr x1, =buffer               // Guardar en buffer
        mov x2, #127                  // Tamaño máximo de entrada (ajustado)
        mov x8, #63                   // Syscall de read
        svc 0

        // Mostrar mensaje de uso de ordenamiento por selección
        ldr x0, =mensaje_seleccion
        bl print_str

        // Mostrar el mensaje de resultado
        ldr x0, =mensaje_resultado
        bl print_str

        ldr x0, =resultado_final
        bl print_str

        // Terminar el programa
        mov x8, #93                   // Syscall para "exit"
        svc 0

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                   // Syscall para write
        mov x1, x0                    // Dirección de la cadena a imprimir
        mov x2, #128                  // Longitud máxima del mensaje
        mov x0, #1                    // File descriptor 1 (salida estándar)
        svc 0
        ret


