// Capítulo 4: sumar dos vectores en paralelo, un hilo por elemento, y comparar con la CPU.
#include <chrono>
#include <cstdio>
#include <vector>
#include "book.h"

constexpr int N = 1 << 24;  // 16 M de elementos
constexpr int HILOS = 256;

__global__ void suma(const float *a, const float *b, float *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];  // el último bloque puede sobrar
}

int main() {
    std::vector<float> a(N), b(N), c(N), ref(N);
    for (int i = 0; i < N; ++i) {
        a[i] = static_cast<float>(i);
        b[i] = static_cast<float>(2 * i);
    }

    auto t0 = std::chrono::steady_clock::now();
    for (int i = 0; i < N; ++i) ref[i] = a[i] + b[i];
    double ms_cpu = std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t0).count();

    float *da, *db, *dc;
    size_t bytes = N * sizeof(float);
    HANDLE_ERROR(cudaMalloc(&da, bytes));
    HANDLE_ERROR(cudaMalloc(&db, bytes));
    HANDLE_ERROR(cudaMalloc(&dc, bytes));
    HANDLE_ERROR(cudaMemcpy(da, a.data(), bytes, cudaMemcpyHostToDevice));
    HANDLE_ERROR(cudaMemcpy(db, b.data(), bytes, cudaMemcpyHostToDevice));

    cudaEvent_t ini, fin;
    HANDLE_ERROR(cudaEventCreate(&ini));
    HANDLE_ERROR(cudaEventCreate(&fin));
    int bloques = (N + HILOS - 1) / HILOS;
    HANDLE_ERROR(cudaEventRecord(ini));
    suma<<<bloques, HILOS>>>(da, db, dc, N);
    CHECK_KERNEL();
    HANDLE_ERROR(cudaEventRecord(fin));
    HANDLE_ERROR(cudaEventSynchronize(fin));
    float ms_gpu = 0;
    HANDLE_ERROR(cudaEventElapsedTime(&ms_gpu, ini, fin));

    HANDLE_ERROR(cudaMemcpy(c.data(), dc, bytes, cudaMemcpyDeviceToHost));
    int errores = 0;
    for (int i = 0; i < N; ++i) errores += (c[i] != ref[i]);

    std::printf("%d elementos, %d bloques de %d hilos\n", N, bloques, HILOS);
    std::printf("CPU:          %8.2f ms\n", ms_cpu);
    std::printf("GPU (kernel): %8.2f ms\n", ms_gpu);
    std::printf("Resultados distintos: %d\n", errores);

    cudaFree(da); cudaFree(db); cudaFree(dc);
    cudaEventDestroy(ini); cudaEventDestroy(fin);
    return errores == 0 ? 0 : 1;
}
