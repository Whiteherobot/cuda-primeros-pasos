cmake_minimum_required(VERSION 3.24)

# Por defecto, la GPU de la máquina que compila; en CI (sin GPU) se pasa una arquitectura fija.
if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
  set(CMAKE_CUDA_ARCHITECTURES native)
endif()

project(cuda_primeros_pasos LANGUAGES CXX CUDA)

# Release por defecto: sin optimizar, el bucle de la CPU sale ~10x más lento y la comparación miente.
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)

foreach(ejemplo 01_hola 02_kernel 03_suma 04_propiedades 05_suma_vectores 06_suma_basica 07_suma_arreglos_cpu 08_suma_arreglos_gpu 09_suma_bloques 10_indice_bloque)
  file(GLOB fuente "${CMAKE_SOURCE_DIR}/src/${ejemplo}.*")
  add_executable(${ejemplo} ${fuente})
  target_include_directories(${ejemplo} PRIVATE common)
endforeach()
