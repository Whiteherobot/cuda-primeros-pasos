// Capítulo 3: usar el índice del bloque para identificar el elemento que se procesa.
#include <cstdio> // Permite imprimir los resultados en la terminal.
#include "book.h" // Incluye las definiciones comunes del proyecto.

#define N 4 // Define cuatro elementos y, por tanto, cuatro bloques.

__global__ void add(const int *a, const int *b, int *c) { // Kernel ejecutado por cada bloque.
    int tid = blockIdx.x; // blockIdx.x vale 0, 1, 2 o 3 según el bloque.
    if (tid < N) c[tid] = a[tid] + b[tid]; // Cada bloque suma el elemento de su índice.
} // Termina el kernel de suma.

int main() { // Punto de entrada del programa.
    int a[N], b[N], c[N]; // Declara los arreglos que comienzan en la CPU.
    int *dev_a, *dev_b, *dev_c; // Declara los punteros para la memoria de la GPU.

    cudaMalloc(reinterpret_cast<void **>(&dev_a), N * sizeof(int)); // Reserva a en la GPU.
    cudaMalloc(reinterpret_cast<void **>(&dev_b), N * sizeof(int)); // Reserva b en la GPU.
    cudaMalloc(reinterpret_cast<void **>(&dev_c), N * sizeof(int)); // Reserva c en la GPU.

    for (int i = 0; i < N; ++i) { // Recorre los cuatro elementos.
        a[i] = i + 1; // Guarda 1, 2, 3 y 4 en el arreglo a.
        b[i] = (i + 1) * 10; // Guarda 10, 20, 30 y 40 en el arreglo b.
    } // Termina la preparación de los datos.

    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice); // Copia a hacia la GPU.
    cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice); // Copia b hacia la GPU.

    add<<<N, 1>>>(dev_a, dev_b, dev_c); // Lanza cuatro bloques con un hilo cada uno.

    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost); // Copia c de regreso a la CPU.

    for (int i = 0; i < N; ++i) { // Recorre los resultados calculados.
        std::printf("Bloque %d: %d + %d = %d\n", i, a[i], b[i], c[i]); // Muestra el índice y la suma.
    } // Termina la impresión de resultados.

    cudaFree(dev_a); // Libera la memoria de a en la GPU.
    cudaFree(dev_b); // Libera la memoria de b en la GPU.
    cudaFree(dev_c); // Libera la memoria de c en la GPU.

    return 0; // Indica que el programa terminó correctamente.
} // Termina la función principal.
