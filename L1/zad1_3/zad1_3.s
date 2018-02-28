.data
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUF_LEN = 512

.bss
.comm buf_read, 512
.comm buf_write, 512
.text
.globl _start

_start:
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $buf_read, %rsi
movq $BUF_LEN, %rdx
syscall

#ZAMIANA ASCII NA LICZBY
dec %rax
dec %rax
movq %rax, %rdi
movq $1, %rsi
movq $0, %r8

petla_zamiana_liczba:
movb buf_read(,%rdi,1), %bl
sub $'0', %bl
movq %rsi, %rax
mul %bl
add %rax, %r8
movq $10, %rax
mul %rsi
movq %rax, %rsi
dec %rdi
cmp $-1, %rdi
jg petla_zamiana_liczba

movq $1, %r9
movq $0, %r10
jmp pierwiastek

koniec:
sub $1, %r10

#ZAMIANA LICZBY NA ASCII
movq $0, %rdi
movq %r10, %rax
movq $10, %r8
petla_zamiana_ascii:
mov $0, %rdx
div %r8
add $'0', %rdx
movb %dl, buf_read(,%rdi,1)
inc %rdi
cmp $0, %rax
jne petla_zamiana_ascii

#OBROT LICZBY W ASCII

movq $0, %rsi
movq %rdi, %rdx
dec %rdi
petla_obrot:
movq buf_read(,%rdi,1), %rax
movq %rax, buf_write(,%rsi,1)
inc %rsi
dec %rdi
cmp %rdx, %rsi
jl petla_obrot

movb $'\n', buf_write(,%rsi,1)
inc %rsi
movq %rsi, %r8

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_write, %rsi
movq %r8, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

pierwiastek:
sub %r9, %r8
add $2, %r9
inc %r10
cmp $0, %r8
jg pierwiastek
jmp koniec
