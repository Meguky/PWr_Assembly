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

.text
.globl _start

_start:
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $buf_read, %rsi
movq $BUF_LENGTH, %rdx
syscall

movq %rax, %rdx

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_read, %rsi
syscall

movq $SYS_EXIT, %rax
movq $SYS_SUCCESS, %rdi
syscall
