/*
https://asciinema.org/a/688673

# =========================================
# Programa: Mínimo Común Múltiplo (MCM)
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Mínimo Común Múltiplo (MCM)
# Codigo en ensamblador y Python
# =========================================

def calcular_mcd(a, b):
    """
    Calcula el Máximo Común Divisor (MCD) de dos números enteros positivos.
    
    Parámetros:
        a (int): Primer número
        b (int): Segundo número
    
    Retorna:
        int: MCD de los dos números
    """
    while b != 0:
        a, b = b, a % b  # Intercambia 'a' con 'b', y 'b' con el residuo de 'a' entre 'b'
    return a

def calcular_mcm(a, b):
    """
    Calcula el Mínimo Común Múltiplo (MCM) de dos números enteros positivos.
    
    Parámetros:
        a (int): Primer número
        b (int): Segundo número
    
    Retorna:
        int: MCM de los dos números
    """
    mcd = calcular_mcd(a, b)
    return abs(a * b) // mcd  # MCM = (a * b) / MCD

# Ejemplo de uso
numero1 = 56
numero2 = 98
mcm = calcular_mcm(numero1, numero2)
print(f"El MCM de {numero1} y {numero2} es: {mcm}")








Ensamblador

*/

/*
 * Calcula el Mínimo Común Múltiplo (MCM) entre dos números enteros positivos.
 *
 * Entrada: Dos números enteros positivos en los registros `w0` y `w1`.
 * Salida: El MCM de los dos números en el registro `w0`.
 */

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar los valores de entrada
    mov     w0, #56                 // Ejemplo: primer número
    mov     w1, #98                 // Ejemplo: segundo número

    // Guardar los valores originales para usarlos después
    mov     w3, w0                  // Guardar primer número en w3
    mov     w4, w1                  // Guardar segundo número en w4

    // Llamar a la función para calcular el MCD
    bl      calcular_mcd            // w0 contendrá el MCD al retornar

    // Calcular MCM usando la fórmula: MCM = (a * b) / MCD
    mul     w5, w3, w4              // w5 = a * b
    udiv    w0, w5, w0              // w0 = (a * b) / MCD, que es el MCM

    // Imprimir el resultado (MCM en w0)
    adrp    x0, msg_mcm             // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_mcm
    mov     w1, w0                  // Pasar el MCM a w1 como argumento para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0                  // Código de salida 0
    ret

// Función calcular_mcd
// Entrada: w0 = primer número, w1 = segundo número
// Salida: w0 = MCD de los dos números
calcular_mcd:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

loop_mcd:
    cmp     w1, #0                  // Comparar w1 con 0
    beq     fin_mcd                 // Si w1 es 0, fin (MCD está en w0)
    udiv    w2, w0, w1              // w2 = w0 / w1
    msub    w2, w2, w1, w0          // w2 = w0 - (w2 * w1) -> residuo
    mov     w0, w1                  // w0 = w1 (intercambiar)
    mov     w1, w2                  // w1 = residuo
    b       loop_mcd                // Repetir mientras w1 no sea 0

fin_mcd:
    ldp     x29, x30, [sp], #16
    ret                             // Retornar el MCD en w0

// Datos
.data
msg_mcm: .string "El MCM es: %d\n"
