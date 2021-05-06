#include <limits.h>
#include <time.h>
#include <stdio.h>
#define N_REPEATS 1000000

void sum_32(float a, float b)
{
    float c;

    for (size_t i = 0; i < N_REPEATS; i++)
        asm("fld %1\n"    //помещает содержимое источника (32-, 64- или 80-битная переменная) в стек FPU 
            "fld %2\n"
            "faddp\n"   //Сложение с выталкиванием из стека ST(0) (результат в ST(i)
            "fstp %0\n" //Считать вещественное число из стека с выталкиванием
            : "=m"(c)
            : "m"(a), "m"(b));
}

void mult_32(float a, float b)
{
    float c;

    for (size_t i = 0; i < N_REPEATS; i++)
        asm("fld %1\n"
            "fld %2\n"
            "fmulp\n"        //Умножение с выталкиванием из стека ST(0) (результат в ST(i)
            "fstp %0\n"
            : "=m"(c)
            : "m"(a), "m"(b));
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
        asm("fld %1\n"
            "fld %2\n"
            "faddp\n"
            "fstp %0\n"
            : "=m"(c)
            : "m"(a), "m"(b));
}

void mult_64(double a, double b)
{
    double c;

    for (size_t i = 0; i < N_REPEATS; i++)
        asm("fld %1\n"
            "fld %2\n"
            "fmulp\n"
            "fstp %0\n"
            : "=m"(c)
            : "m"(a), "m"(b)
            : );
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

void sum_80(__float80 a, __float80 b)
{
    __float80 c;

    for (size_t i = 0; i < N_REPEATS; i++)
        asm("fld %1\n"
            "fld %2\n"
            "faddp\n"
            "fstp %0\n"
            : "=m"(c)
            : "m"(a), "m"(b));
}

void mult_80(__float80 a, __float80 b)
{
    __float80 c;

    for (size_t i = 0; i < N_REPEATS; ++i)
        asm("fld %1\n"
            "fld %2\n"
            "fmulp\n"
            "fstp %0\n"
            : "=m"(c)
            : "m"(a), "m"(b));
}

void measure_80(void)
{
    printf("Measures for __float80 (size=%zu bytes)\n", sizeof(__float80) * CHAR_BIT);
    __float80 a = 2e40, b = 11e100;

    clock_t begin = clock();
    sum_80(a, b);
    clock_t end = clock();
    printf("SUM: %.3e sec\n", (float)(end - begin) / (CLOCKS_PER_SEC));


    begin = clock();
    mult_80(a, b);
    end = clock();
    printf("MULT: %.3e sec\n\n", ((float)(end - begin)) / (CLOCKS_PER_SEC));
}

int main(void)
{
    printf("Everything is measured for %d repeats\n", N_REPEATS);
    measure_32();
    measure_64();
    measure_80();
    return 0;
}