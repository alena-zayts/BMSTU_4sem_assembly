del *.o *.s *.exe
pause

echo using assembly parts
gcc -c -masm=intel -o compare_with_asm.o compare_with_asm.c
gcc -o compare_with_asm.exe compare_with_asm.o 
call compare_with_asm.exe

echo using -m80387 option
gcc -std=c99 -m80387 -c compare_with_c1.c 
objdump -d -S compare_with_c1.o
gcc -std=c99 -m80387 -o compare_with_c1.exe compare_with_c1.o 
call compare_with_c1.exe

echo using -mno-80387 option
gcc -std=c99 -mno-80387 -c compare_with_c2.c 
objdump -d -S compare_with_c2.o
gcc -std=c99 -mno-80387 -o compare_with_c2.exe compare_with_c2.o 
call compare_with_c2.exe

pause

