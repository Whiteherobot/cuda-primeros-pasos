// Capítulo 3: el primer kernel. No hace nada, pero se ejecuta en la GPU.
#include <cstdio>
#include "book.h"

__global__ void kernel() {}

int main() {
    kernel<<<1, 1>>>();
    CHECK_KERNEL();
    HANDLE_ERROR(cudaDeviceSynchronize());
    std::printf("Hola, mundo desde un programa con kernel!\n");
    return 0;
}
