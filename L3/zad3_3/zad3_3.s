.data
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUF_LEN = 512

.bss
.comm buf_write, 512
.comm buf_write_reversed, 512
.comm znak, 512
.text
.globl _start
_start:
nop

#Parametr do funkcji
movq $3, %rax

call rekurencja_stos

movq $0, %r10
cmp $0, %rbx
jge nieujemna
not %rbx
inc %rbx
inc %r10

nieujemna:

movq %rbx, %rax
movq $10, %rbx
movq $0, %rcx

zamiana:
movq $0, %rdx
div %rbx

add $'0', %rdx
movb %dl, buf_write_reversed(,%rcx,1)

inc %rcx
cmp $0, %rax
jne zamiana

movq $0, %rdi
movq %rcx, %rsi
dec %rsi

odwrot:
movq buf_write_reversed(,%rsi,1), %rax
movq %rax, buf_write(,%rdi,1)

inc %rdi
dec %rsi
cmp %rcx, %rdi
jle odwrot

movq %rdi, %r8

cmp $0, %r10
je dodatnia

movq $0, %rdi
movb $'-', znak(,%rdi,1)


movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $znak, %rsi
movq $1, %rdx
syscall

dodatnia:


movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_write, %rsi
movq %r8, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

rekurencja_stos:

push %rbp
movq %rsp, %rbp
sub $8, %rsp
movq $5, %r9

cmp $1, %rax
jl zero
je jeden

movq $0, %rcx

dec %rax

push %rcx
push %rax
call rekurencja_stos
movq %rbx, %rax
mul %r9
movq %rax, %rbx
pop %rax
pop %rcx
sub %rbx, %rcx

dec %rax

push %rcx
push %rax
call rekurencja_stos
pop %rax
pop %rcx
add %rbx, %rcx

movq %rcx, %rbx
movq %rbp, %rsp
pop %rbp
ret

zero:
movq $3, %rbx
movq %rbp, %rsp
pop %rbp
ret

jeden:
movq $1, %rbx
movq %rbp, %rsp
pop %rbp
ret


