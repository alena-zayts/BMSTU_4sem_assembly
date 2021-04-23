	.file	"main.c"
	.text
	.globl	asm_strlen
	.def	asm_strlen;	.scl	2;	.type	32;	.endef
	.seh_proc	asm_strlen
asm_strlen:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	subq	$24, %rsp
	.seh_stackalloc	24
	leaq	128(%rsp), %rbp
	.seh_setframe	%rbp, 128
	.seh_endprologue
	movq	%rcx, -80(%rbp)
	movl	$0, -116(%rbp)
	movq	-80(%rbp), %rdx
/APP
 # 27 "main.c" 1
	.intel_syntax noprefix
	mov al, 0
	lea rdi, [%rdx]
	mov ecx, 0xffffffff
	repne scasb
	mov eax, 0xffffffff
	sub eax, ecx
	dec eax
	mov %edx, eax
	
 # 0 "" 2
/NO_APP
	movl	%edx, -116(%rbp)
	movl	-116(%rbp), %eax
	addq	$24, %rsp
	popq	%rdi
	popq	%rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "\12Test asm_strlen\12\0"
.LC1:
	.ascii "123456789\0"
.LC2:
	.ascii "1) String: '%s'\12\0"
.LC3:
	.ascii "    Passed\0"
.LC4:
	.ascii "    ERROR!!!!!!\0"
.LC5:
	.ascii "1\0"
.LC6:
	.ascii "2) String: '%s'\12\0"
.LC7:
	.ascii "\0"
	.text
	.globl	test_asm_strlen
	.def	test_asm_strlen;	.scl	2;	.type	32;	.endef
	.seh_proc	test_asm_strlen
test_asm_strlen:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	leaq	128(%rsp), %rbp
	.seh_setframe	%rbp, 128
	.seh_endprologue
	leaq	.LC0(%rip), %rcx
	call	puts
	leaq	.LC1(%rip), %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC2(%rip), %rcx
	call	printf
	movq	-88(%rbp), %rax
	movq	%rax, %rcx
	call	asm_strlen
	movslq	%eax, %rbx
	movq	-88(%rbp), %rax
	movq	%rax, %rcx
	call	strlen
	cmpq	%rax, %rbx
	jne	.L4
	leaq	.LC3(%rip), %rcx
	call	puts
	jmp	.L5
.L4:
	leaq	.LC4(%rip), %rcx
	call	puts
.L5:
	leaq	.LC5(%rip), %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rcx
	call	printf
	movq	-88(%rbp), %rax
	movq	%rax, %rcx
	call	asm_strlen
	movslq	%eax, %rbx
	movq	-88(%rbp), %rax
	movq	%rax, %rcx
	call	strlen
	cmpq	%rax, %rbx
	jne	.L6
	leaq	.LC3(%rip), %rcx
	call	puts
	jmp	.L7
.L6:
	leaq	.LC4(%rip), %rcx
	call	puts
.L7:
	leaq	.LC7(%rip), %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rcx
	call	printf
	movq	-88(%rbp), %rax
	movq	%rax, %rcx
	call	asm_strlen
	movslq	%eax, %rbx
	movq	-88(%rbp), %rax
	movq	%rax, %rcx
	call	strlen
	cmpq	%rax, %rbx
	jne	.L8
	leaq	.LC3(%rip), %rcx
	call	puts
	jmp	.L10
.L8:
	leaq	.LC4(%rip), %rcx
	call	puts
.L10:
	nop
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC8:
	.ascii "\12Test asm_strncpy\12\0"
	.align 8
.LC9:
	.ascii "Test1: src and dst are in different places.\12src = '%s'\12dest - '%s'\12\12asm_strncpy(dest, src, 2)\12\0"
.LC10:
	.ascii "Result: %s\12\12\0"
	.align 8
.LC11:
	.ascii "Test2: src and dst are in one place.\12dest = '%s'\12\12asm_strncpy(dest, dest+5, 3)\0"
.LC12:
	.ascii "asm_strncpy(dest+5, dest, 3)\0"
	.text
	.globl	test_asm_strncopy
	.def	test_asm_strncopy;	.scl	2;	.type	32;	.endef
	.seh_proc	test_asm_strncopy
test_asm_strncopy:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	subq	$168, %rsp
	.seh_stackalloc	168
	leaq	128(%rsp), %rbp
	.seh_setframe	%rbp, 128
	.seh_endprologue
	leaq	.LC8(%rip), %rcx
	call	puts
	movabsq	$4050765991979987505, %rax
	movq	%rax, 18(%rbp)
	movw	$57, 26(%rbp)
	movabsq	$3617292328856139833, %rax
	movq	%rax, -96(%rbp)
	movq	$49, -88(%rbp)
	leaq	-80(%rbp), %rdx
	movl	$0, %eax
	movl	$10, %ecx
	movq	%rdx, %rdi
	rep stosq
	movq	%rdi, %rdx
	movl	%eax, (%rdx)
	addq	$4, %rdx
	leaq	-96(%rbp), %rdx
	leaq	18(%rbp), %rax
	movq	%rdx, %r8
	movq	%rax, %rdx
	leaq	.LC9(%rip), %rcx
	call	printf
	movl	$2, 28(%rbp)
	movl	28(%rbp), %ecx
	leaq	18(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movl	%ecx, %r8d
	movq	%rax, %rcx
	call	asm_strncpy
	leaq	-96(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rcx
	call	printf
	leaq	18(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC11(%rip), %rcx
	call	printf
	leaq	-96(%rbp), %rax
	addq	$5, %rax
	leaq	-96(%rbp), %rcx
	movl	$3, %r8d
	movq	%rax, %rdx
	call	asm_strncpy
	leaq	-96(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rcx
	call	printf
	leaq	.LC12(%rip), %rcx
	call	puts
	leaq	-96(%rbp), %rax
	addq	$5, %rax
	leaq	-96(%rbp), %rdx
	movl	$3, %r8d
	movq	%rax, %rcx
	call	asm_strncpy
	leaq	-96(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rcx
	call	printf
	nop
	addq	$168, %rsp
	popq	%rdi
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	call	__main
	movl	$1, %ecx
	movq	__imp___acrt_iob_func(%rip), %rax
	call	*%rax
	movl	$0, %edx
	movq	%rax, %rcx
	call	setbuf
	call	test_asm_strlen
	call	test_asm_strncopy
	movl	$0, %eax
	addq	$32, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	asm_strncpy;	.scl	2;	.type	32;	.endef
	.def	setbuf;	.scl	2;	.type	32;	.endef
