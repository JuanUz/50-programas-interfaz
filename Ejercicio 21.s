/*
https://asciinema.org/a/688648

# =========================================
# Programa: Transposición de una matriz
# Autor: Garcia Ornelas Juan Carlos
# Descripción: Programa para transponer una matriz 3x3
# Codigo en python y en ensamblador
# =========================================


# Matriz 3x3 de entrada
matrixA = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

# Función para transponer una matriz
def transpose(matrix):
    rows = len(matrix)
    cols = len(matrix[0])
    
    # Crear matriz vacía de transpuesta con dimensiones invertidas
    result = [[0 for _ in range(rows)] for _ in range(cols)]
    
    # Realizar la transposición
    for i in range(rows):
        for j in range(cols):
            result[j][i] = matrix[i][j]
    
    return result

# Función para imprimir una matriz
def print_matrix(matrix, title="Matriz"):
    print(f"{title}:")
    for row in matrix:
        print(" ".join(f"{num}" for num in row))
    print()

# Imprimir matriz original
print_matrix(matrixA, "Matriz A")

# Transponer y mostrar resultado
matrixT = transpose(matrixA)
print_matrix(matrixT, "Matriz Transpuesta")










Ensamblador
*/

.data
    // Matriz 3x3 de entrada
    matrixA:     .quad   1, 2, 3
                 .quad   4, 5, 6
                 .quad   7, 8, 9

    // Matriz de resultado (transpuesta)
    result:      .zero   72            // 9 elementos * 8 bytes

    // Mensajes para imprimir
    msgA:        .string "Matriz A:\n"
    msgR:        .string "Matriz Transpuesta:\n"
    format:      .string "%ld "         // Formato para imprimir números de 64 bits
    newline:     .string "\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje para matriz A
    adrp    x0, msgA
    add     x0, x0, :lo12:msgA
    bl      printf

    // Imprimir matriz A
    adrp    x0, matrixA
    add     x0, x0, :lo12:matrixA
    bl      print_matrix

    // Realizar transposición
    adrp    x0, matrixA
    add     x0, x0, :lo12:matrixA
    adrp    x1, result
    add     x1, x1, :lo12:result
    bl      transpose_matrix

    // Imprimir mensaje para matriz transpuesta
    adrp    x0, msgR
    add     x0, x0, :lo12:msgR
    bl      printf

    // Imprimir matriz transpuesta
    adrp    x0, result
    add     x0, x0, :lo12:result
    bl      print_matrix

    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para transponer la matriz
transpose_matrix:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    mov     x3, #0                    // i = 0 (fila)

outer_loop:
    cmp     x3, #3                    // Comparar i con tamaño
    b.ge    end_outer
    mov     x4, #0                    // j = 0 (columna)

inner_loop:
    cmp     x4, #3                    // Comparar j con tamaño
    b.ge    end_inner

    // Calcular índices y cargar elementos
    mov     x5, x3                    // i
    lsl     x5, x5, #4                // i * 16 (i * 8 * 2)
    add     x5, x5, x4, lsl #3        // + j * 8
    ldr     x6, [x0, x5]              // Cargar A[i][j]

    // Guardar en la posición transpuesta
    mov     x7, x4                    // j
    lsl     x7, x7, #4                // j * 16
    add     x7, x7, x3, lsl #3        // + i * 8
    str     x6, [x1, x7]              // Guardar en result[j][i]

    add     x4, x4, #1                // j++
    b       inner_loop

end_inner:
    add     x3, x3, #1                // i++
    b       outer_loop

end_outer:
    ldp     x29, x30, [sp], #16
    ret

// Función para imprimir una matriz
print_matrix:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    mov     x19, x0                    // Guardar dirección de la matriz

    mov     x20, #0                    // i = 0
print_outer:
    cmp     x20, #3
    b.ge    print_end
    mov     x21, #0                    // j = 0

print_inner:
    cmp     x21, #3
    b.ge    print_inner_end

    // Calcular índice y cargar valor
    mov     x22, x20                   // i
    lsl     x22, x22, #4               // i * 16
    add     x22, x22, x21, lsl #3      // + j * 8
    ldr     x1, [x19, x22]             // Cargar elemento

    // Imprimir valor
    adrp    x0, format
    add     x0, x0, :lo12:format
    bl      printf

    add     x21, x21, #1              // j++
    b       print_inner

print_inner_end:
    // Imprimir nueva línea
    adrp    x0, newline
    add     x0, x0, :lo12:newline
    bl      printf

    add     x20, x20, #1              // i++
    b       print_outer

print_end:
    ldp     x29, x30, [sp], #16
    ret
