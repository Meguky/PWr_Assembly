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

dec %rax
movq $0, %rdi

petla:
movb buf_read(,%rdi,1), %bh

cmp $'Z', %bh
jg przypisz
cmp $'0', %bh
jl przypisz
cmp $'0', %bh
jg numer

przypisz:
movb %bh, buf_write(,%rdi,1)
inc %rdi
cmp %rax, %rdi
jl petla

koniec:
movb $'\n', buf_write(,%rdi,1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_write, %rsi
movq $BUF_LEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

numer:
cmp $'9', %bh
jg duza
add $5, %bh
jmp przypisz

duza:
cmp $'A', %bh
jl przypisz
add $3, %bh
jmp przypisz
