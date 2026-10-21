// Capítulo 3: pasar parámetros a un kernel y traer el resultado de la memoria de la GPU.
#include <cstdio>
#include "book.h"

__global__ void suma(int a, int b, int *c) { *c = a + b; }

int main() {
    int c = 0;
    int *dev_c = nullptr;
    HANDLE_ERROR(cudaMalloc(&dev_c, sizeof(int)));

    suma<<<1, 1>>>(2, 7, dev_c);
    CHECK_KERNEL();
    HANDLE_ERROR(cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost));

    std::printf("2 + 7 = %d\n", c);
    HANDLE_ERROR(cudaFree(dev_c));
    return c == 9 ? 0 : 1;
}
