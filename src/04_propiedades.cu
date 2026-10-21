// Capítulo 3: consultar las GPUs disponibles y sus límites.
#include <cstdio>
#include "book.h"

int main() {
    int n = 0;
    HANDLE_ERROR(cudaGetDeviceCount(&n));
    std::printf("GPUs CUDA: %d\n", n);

    for (int i = 0; i < n; ++i) {
        cudaDeviceProp p;
        HANDLE_ERROR(cudaGetDeviceProperties(&p, i));
        std::printf("\n[%d] %s\n", i, p.name);
        std::printf("  Compute capability:   %d.%d\n", p.major, p.minor);
        std::printf("  Memoria global:       %.1f GB\n", p.totalGlobalMem / 1073741824.0);
        std::printf("  Multiprocesadores:    %d\n", p.multiProcessorCount);
        std::printf("  Hilos por bloque:     %d\n", p.maxThreadsPerBlock);
        std::printf("  Memoria compartida:   %zu KB por bloque\n", p.sharedMemPerBlock / 1024);
        std::printf("  Tamaño de warp:       %d\n", p.warpSize);
        std::printf("  Bloques máx. (x,y,z): %d, %d, %d\n",
                    p.maxGridSize[0], p.maxGridSize[1], p.maxGridSize[2]);
    }
    return 0;
}
