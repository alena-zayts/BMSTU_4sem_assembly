#include <limits.h>
#include <time.h>
#include <stdio.h>
#define N_REPEATS 1000000000
#define ND 4

void count_scalar_product_c(double* a, double* b)
{
    double c;
    for (size_t i = 0; i < N_REPEATS; i++)
    {
        c = 0;
        for (size_t j = 0; j < ND; j++)
            c += a[j] * b[j];
    }
}

void count_scalar_product_asm(double *a, double *b)
{
    double c;
    double(*ptr_a)[ND] = a;
    double(*ptr_b)[ND] = b;
    for (size_t i = 0; i < N_REPEATS; i++)
    {
        {
            asm volatile(
                // записывается в младший 0, старший 3
                "vmovupd ymm0, %1\n"
                "vmovupd ymm1, %2\n"
                // в ymm0 - вектор-произведение элементов a и b
                "vmulpd ymm0, ymm0, ymm1\n"             
                // в ymm1 пр[2] + пр[3], пр[2] + пр[3], пр[0] + пр[1], пр[0] + пр[1]
                "vhaddpd ymm1, ymm0, ymm0\n"     
                // извлекаем старшие биты
                "vextractf128 xmm0, ymm1, 1\n" 
                // складываем с младшими
                "vaddpd ymm0, ymm1, ymm0\n"
                // перемещаем самый младший double
                "movlpd %0, xmm0\n"
                :
                : "m"(c), "m"(*ptr_a), "m"(*ptr_b)
                : "ymm0", "ymm1", "memory");
        }
    }
}

int main(void)
{
    printf("Counted scalar product for %dd-vectors of double %d times\n", ND, N_REPEATS);
    double a[ND] = { 0, 1, 2, 3};
    double b[ND] = { 0, 1, 2, 3};

    clock_t begin = clock();
    count_scalar_product_c(a, b);
    clock_t end = clock();
    printf("Using code in C: %.3e sec\n", (float)(end - begin) / (CLOCKS_PER_SEC));

    begin = clock();
    count_scalar_product_asm(a, b);
    end = clock();
    printf("Using code in ASM: %.3e sec\n", (float)(end - begin) / (CLOCKS_PER_SEC));

    return 0;
}

