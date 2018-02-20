.data
SYSWRITE = 1
SYSREAD = 0
STDOUT = 1
STDIN = 0
SYS_EXIT = 60
SYS_SUCCESS = 0
BUF_LENGTH = 512

buf: .ascii "Hello, World!"
buf_len = .-buf

.bss
.lcomm buf_read, 512
.lcomm buf_write, 512

.text
.globl _start

_start:
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $buf_read, %rsi
movq $BUF_LENGTH, %rdx
syscall

dec %rax
movq $0, %rdi

zamien_wielkosc_liter:
movb buf_read(, %rdi, 1), %bh
#cmp $'A', %bh
#jl nie_litera
#cmp $'z', %bh
#jg nie_litera
#cmp $'Z', %bh
#jg nie_litera
#cmp $'a', %bh
#jl nie_litera
movb $0x20, %bl
xor %bh, %bl
movb %bl, buf_write(,%rdi,1)
inc %rdi
cmp %rax, %rdi
jl zamien_wielkosc_liter

movb $'\n', buf_write(,%rdi,1)

nie_litera:
movb %bh, buf_write(,%rdi,1)
inc %rdi
cmp %rax, %rdi
jl zamien_wielkosc_liter

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_write, %rsi
movq $BUF_LENGTH, %rdx
syscall

movq $SYS_EXIT, %rax
movq $SYS_SUCCESS, %rdi
syscall
