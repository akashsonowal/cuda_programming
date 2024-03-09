#include <stdio.h>

__global__ void add(int* a, int* b, int* c){
    int i = threadIdx.x + blockDim.x * blockIdx.x;
    c[i] = a[i] + b[i];
}

__managed__ int vector_a[256], vector_b[256], vector_c[256]; // memory space specifier for both CPU and GPU

int main(){ // cpu that runs cuda kernel
    for (int i = 0; i < 256; i++){
        vector_a[i] = i;
        vector_b[i] = 256 - i;
    }

    add<<<1, 256>>>(vector_a, vector_b, vector_c); // <<<Blocks, Threads per block>>> cuda kernel call
    cudaDeviceSynchronize(); // waiting for all threads to complete

    int result_sum = 0;

    for (int i = 0; i < 256; i++){
        result_sum += vector_c[i];
    }

    printf("Hi Mom! I added vectors add on GPU");
    printf("Result: sum = % d", result_sum);
}
