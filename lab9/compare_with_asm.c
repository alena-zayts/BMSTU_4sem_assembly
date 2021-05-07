#include <limits.h>
#include <time.h>
#include <stdio.h>
#define N_REPEATS 1000000

void sum_32(float a, float b)
{
    float c;

    for (size_t i = 0; i < N_REPEATS; i++)
        asm("fld %1\n"    //�������� ���������� ��������� (32-, 64- ��� 80-������ ����������) � ���� FPU 
            "fld %2\n"
            "faddp\n"   //�������� � ������������� �� ����� ST(0) (��������� � ST(i)
            "fstp %0\n" //������� ������������ ����� �� ����� � �������������
            : "=m"(c)
            : "m"(a), "m"(b));
}

void mult_32(float a, float b)
{
    float c;

    for (size_t i = 0; i < N_REPEATS; i++)
        asm("fld %1\n"
            "fld %2\n"
            "fmulp\n"        //��������� � ������������� �� ����� ST(0) (��������� � ST(i)
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

void cmp_sin(void)
{
    printf("Comparing accuracy of sin calcullations:\n");
    double pi1 = 3.14, pi2 = 3.141596;
    double counted_sin1, counted_sin2, counted_sin3;

    asm("fld %1\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(counted_sin1)
        : "m"(pi1));

    asm("fld %1\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(counted_sin2)
        : "m"(pi2));

    asm("fldpi\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(counted_sin3));


    printf("Sin(pi): \nsin(3.14)=    %e, \nsin(3.141596)=%e, \nsin(pi)=      %e\n\n", counted_sin1, counted_sin2, counted_sin3);
}

void cmp_sin2(void)
{
    double pi1 = 3.14, pi2 = 3.141596;
    double counted_sin1, counted_sin2, counted_sin3;

    asm("fld %1\n"
        "fld1\n"
        "fld1\n"
        "faddp\n"
        "fdivp\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(counted_sin1)
        : "m"(pi1));


    asm("fld %1\n"
        "fld1\n"
        "fld1\n"
        "faddp\n"
        "fdivp\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(counted_sin2)
        : "m"(pi2));

    asm("fldpi\n"
        "fld1\n"
        "fld1\n"
        "faddp\n"
        "fdiv\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(counted_sin3));

    printf("Sin(pi/2): \nsin(3.14/2)=    %e, \nsin(3.141596/2)=%e, \nsin(pi/2)=      %e\n\n", counted_sin1, counted_sin2, counted_sin3);
    
}

int main(void)
{
    printf("Everything is measured for %d repeats\n", N_REPEATS);
    measure_32();
    measure_64();
    measure_80();

    cmp_sin();
    cmp_sin2();
    return 0;
}