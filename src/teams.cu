#include <cstdio> 
#include "book.h" 

#define N 8

__global__ void es_primo(const int *a, int *b) { 
    int tid = blockIdx.x; 
    if (tid >= N) return; 

    int numero = a[tid]; 
    b[tid] = 1;

    if (numero < 2) { 
        b[tid] = 0; 
        return; 
    }

    for (int divisor = 2; divisor * divisor <= numero; ++divisor) { 
        if (numero % divisor == 0) { 
            b[tid] = 0; 
            break; 
        }
    }
} 

int main() { 
    int a[N] = {2, 15, 17, 1, 23, 49, 0, -7}; 
    int b[N] = {}; 
    int *dev_a, *dev_b; 

    cudaMalloc(reinterpret_cast<void **>(&dev_a), N * sizeof(int)); 
    cudaMalloc(reinterpret_cast<void **>(&dev_b), N * sizeof(int)); 

    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice); 

    es_primo<<<N, 1>>>(dev_a, dev_b); 

    cudaMemcpy(b, dev_b, N * sizeof(int), cudaMemcpyDeviceToHost); 

    std::printf("\nSalida:  "); 
    for (int i = 0; i < N; ++i) { 
        std::printf("%d ", b[i]); 
    }

    cudaFree(dev_a); 
    cudaFree(dev_b); 

    return 0; 
} 
