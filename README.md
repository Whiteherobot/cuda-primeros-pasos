# Primeros pasos con CUDA

[![CI](https://github.com/Whiteherobot/cuda-primeros-pasos/actions/workflows/ci.yml/badge.svg)](https://github.com/Whiteherobot/cuda-primeros-pasos/actions/workflows/ci.yml)

Ejemplos de los capítulos 3 y 4 de *CUDA by Example* (Sanders y Kandrot), reescritos con CMake
y con control de errores en cada llamada a la API. Los armé para probar el toolkit en mi laptop
(RTX 4060, CUDA 13) antes de usarlo en las prácticas de Visión por Computador.

| Ejemplo | Qué muestra |
|---|---|
| `01_hola.cpp` | Que la cadena de CUDA compila C++ normal |
| `02_kernel.cu` | Lanzar un kernel (`<<<1, 1>>>`) y sincronizar |
| `03_suma.cu` | Pasar parámetros y traer el resultado con `cudaMalloc` y `cudaMemcpy` |
| `04_propiedades.cu` | Las GPUs disponibles y sus límites (`cudaGetDeviceProperties`) |
| `05_suma_vectores.cu` | Un hilo por elemento, cómo calcular los bloques y tiempos con eventos CUDA |
| `06_suma_basica.cu` | Reservar memoria en la GPU, ejecutar una suma y copiar el resultado |
| `07_suma_arreglos_cpu.cu` | Sumar dos arreglos secuencialmente en la CPU |
| `08_suma_arreglos_gpu.cu` | Copiar dos arreglos a la GPU, sumarlos con un kernel y recuperar el resultado |
| `09_suma_bloques.cu` | Procesar los arreglos con un bloque y un hilo por cada elemento |
| `10_indice_bloque.cu` | Usar `blockIdx.x` para asignar un elemento diferente a cada bloque |

`common/book.h` trae `HANDLE_ERROR`, que corta el programa con el archivo y la línea si una
llamada falla, y `CHECK_KERNEL`, porque los lanzamientos de kernel no devuelven error por sí
solos.

## Compilar y ejecutar

Requiere el CUDA Toolkit 12 o posterior y CMake 3.24 o posterior.

```bash
cmake -S . -B build          # compila para la GPU de esta máquina
cmake --build build -j
./build/05_suma_vectores
```

Salida en la RTX 4060:

```
16777216 elementos, 65536 bloques de 256 hilos
CPU:              7.71 ms
GPU (kernel):     0.92 ms
Resultados distintos: 0
```

El tiempo de la GPU es solo el del kernel. Copiar los 192 MB entre la CPU y la GPU tarda
bastante más que la suma, así que para una operación tan simple la GPU no conviene: la ventaja
aparece cuando los datos ya están en la GPU o cuando el cálculo por elemento es pesado.

## Licencia

MIT. Ver [LICENSE](LICENSE).
