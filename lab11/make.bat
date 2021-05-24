\masm32\bin\ml /c /coff /Cp lab_11.asm 
\masm32\bin\rc rsrc.rc
\masm32\bin\link /subsystem:windows lab_11.obj rsrc.res
del lab_11.obj
del rsrc.res
pause