// Capítulo 3: reservar arreglos en la GPU y sumarlos con un kernel.
#include <cstdio> // Permite imprimir los resultados en la terminal.
#include "book.h" // Incluye las definiciones comunes del proyecto.

#define N 10 // Define la cantidad de elementos de cada arreglo.

__global__ void add(const int *a, const int *b, int *c) { // Kernel que suma los arreglos en la GPU.
    int tid = blockIdx.x * blockDim.x + threadIdx.x; // Calcula el índice único del hilo.
    if (tid < N) c[tid] = a[tid] + b[tid]; // Suma un elemento si el índice está dentro del arreglo.
} // Termina el kernel de suma.

int main() { // Punto de entrada del programa.
    int a[N], b[N], c[N]; // Declara los arreglos que viven inicialmente en la CPU.
    int *dev_a, *dev_b, *dev_c; // Declara punteros para los arreglos de la GPU.

    cudaMalloc(reinterpret_cast<void **>(&dev_a), N * sizeof(int)); // Reserva memoria para a en la GPU.
    cudaMalloc(reinterpret_cast<void **>(&dev_b), N * sizeof(int)); // Reserva memoria para b en la GPU.
    cudaMalloc(reinterpret_cast<void **>(&dev_c), N * sizeof(int)); // Reserva memoria para c en la GPU.

    for (int i = 0; i < N; ++i) { // Recorre las posiciones para preparar los datos en la CPU.
        a[i] = -i; // Guarda el valor negativo del índice en a.
        b[i] = i * i; // Guarda el cuadrado del índice en b.
    } // Termina la inicialización de los arreglos.

    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice); // Copia a desde la CPU hacia la GPU.
    cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice); // Copia b desde la CPU hacia la GPU.

    add<<<N, 1>>>(dev_a, dev_b, dev_c); // Ejecuta un bloque con un hilo para cada elemento.

    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost); // Copia c desde la GPU hacia la CPU.

    for (int i = 0; i < N; ++i) { // Recorre los resultados para mostrarlos.
        std::printf("%d + %d = %d\n", a[i], b[i], c[i]); // Imprime cada suma calculada.
    } // Termina la impresión de resultados.

    cudaFree(dev_a); // Libera la memoria de a en la GPU.
    cudaFree(dev_b); // Libera la memoria de b en la GPU.
    cudaFree(dev_c); // Libera la memoria de c en la GPU.

    return 0; // Indica que el programa terminó correctamente.
} // Termina la función principal.
