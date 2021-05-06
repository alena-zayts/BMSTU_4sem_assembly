
#include <limits.h>
#include <time.h>
#include <stdio.h>
#define N_REPEATS 1000000

void sum_32(float a, float b)
{
    float c;
    for (size_t i = 0; i < N_REPEATS; i++)
        c = a + b;
}

void mult_32(float a, float b)
{
    float c;
    for (size_t i = 0; i < N_REPEATS; i++)
        c = a * b;
}

void measure_32(void)
{
    printf("Measures for float (size=%zu bytes)\n", sizeof(float) * CHAR_BIT);

    float a = 2e8, b = 11e20;

    clock_t begin = clock();
    sum_32(a, b);
    clock_t end = clock();
    printf("SUM: %.3e sec\n", (float)(end - begin) / (CLOCKS_PER_SEC));

    begin = clock();
    mult_32(a, b);
    end = clock();

    printf("MULT: %.3e sec\n\n", (float)(end - begin) / (CLOCKS_PER_SEC));

}
void sum_64(double a, double b)
{
    double c;
    for (size_t i = 0; i < N_REPEATS; i++)
        c = a + b;
}

void mult_64(double a, double b)
{
    double c;
    for (size_t i = 0; i < N_REPEATS; i++)
        c = a * b;
}

void measure_64(void)
{
    printf("Measures for double (size=%zu bytes)\n", sizeof(double) * CHAR_BIT);
    double a = 2e40, b = 11e100;

    clock_t begin = clock();
    sum_64(a, b);
    clock_t end = clock();
    printf("SUM: %.3e sec\n", (float)(end - begin) / (CLOCKS_PER_SEC));


    begin = clock();
    mult_64(a, b);
    end = clock();
    printf("MULT: %.3e sec\n\n", ((float)(end - begin)) / (CLOCKS_PER_SEC));
}


int main(void)
{
    printf("Everything is measured for %d repeats\n", N_REPEATS);
    measure_32();
    measure_64();
    return 0;
}