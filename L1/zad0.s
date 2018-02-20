.data
SYSWRITE = 1
SYSREAD = 0
STDOUT = 1
STDIN = 0
SYS_EXIT = 60
SYS_SUCCESS = 0

buf: .ascii "Hello, World!\n"
buf_len = .-buf

.globl _start

_start:

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf, %rsi
movq $buf_len, %rdx
syscall

movq $SYS_EXIT, %rax
movq $SYS_SUCCESS, %rdi
syscall
