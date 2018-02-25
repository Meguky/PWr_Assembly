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
.comm buf_read_len, 512
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
movq %rax, buf_read_len
movq $0, %rdi

wczytywanie:
movb buf_read(,%rdi,1), %bh
jmp mnoznik
zamiana:
imul %bh
add %rax, buf_write
inc %rdi
cmp buf_read_len, %rdi
jl wczytywanie


movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_write, %rsi
movq $BUF_LEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

mnoznik:
movq buf_read_len, %rdx
sub %rdi, %rdx
movq $1, %rax
movq $1, %rcx
movb $7, %bl
jmp potega

potega:
cmp $1, %rdx
je zwroc_1
imul %bl
inc %rcx
cmp %rdx, %rcx
jl potega
jmp zamiana

zwroc_1:
movq $1, %rax
jmp zamiana
