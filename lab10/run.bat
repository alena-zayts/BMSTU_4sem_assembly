gcc -c -w -O0 -masm=intel -o main.o main.c
gcc -o main.exe main.o 
call main.exe
pause