// Capítulo 3: sumar dos valores en un kernel y copiar el resultado desde la GPU.
#include <cstdio>
#include "book.h"

__global__ void suma(int a, int b, int *c) {
    *c = a + b;
}

int main() {
    int c = 0;
    int *dev_c = nullptr;

    cudaMalloc(reinterpret_cast<void **>(&dev_c), sizeof(int));
    suma<<<1, 1>>>(2, 7, dev_c);
    cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);

    std::printf("2 + 7 = %d\n", c);
    cudaFree(dev_c);
    return 0;
}
