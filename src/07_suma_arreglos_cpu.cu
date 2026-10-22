// Capítulo 3: sumar dos arreglos de forma secuencial en la CPU.
#include <cstdio> // Permite imprimir los resultados en la terminal.
#include "book.h" // Incluye las utilidades comunes del curso.

#define N 10 // Define la cantidad de elementos de cada arreglo.

void add(const int *a, const int *b, int *c) { // Suma dos arreglos y guarda el resultado.
    int tid = 0; // En la CPU comenzamos con el índice cero.
    while (tid < N) { // Recorre los elementos mientras el índice sea válido.
        c[tid] = a[tid] + b[tid]; // Suma los elementos correspondientes de ambos arreglos.
        tid += 1; // Avanza al siguiente elemento.
    } // Termina el recorrido de los arreglos.
} // Termina la función que suma los arreglos.

int main() { // Punto de entrada del programa.
    int a[N], b[N], c[N]; // Declara los arreglos de entrada y el arreglo de salida.

    for (int i = 0; i < N; ++i) { // Recorre las posiciones para llenar los arreglos.
        a[i] = -i; // Guarda el valor negativo del índice en el arreglo a.
        b[i] = i * i; // Guarda el cuadrado del índice en el arreglo b.
    } // Termina la inicialización de los arreglos.

    add(a, b, c); // Ejecuta la suma de los arreglos en la CPU.

    for (int i = 0; i < N; ++i) { // Recorre los resultados para mostrarlos.
        std::printf("%d + %d = %d\n", a[i], b[i], c[i]); // Imprime cada suma.
    } // Termina la impresión de los resultados.

    return 0; // Indica que el programa terminó correctamente.
} // Termina la función principal.
