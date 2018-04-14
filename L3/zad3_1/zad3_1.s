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
.comm buf_write_reversed, 512

.text
.globl _start
_start:
nop

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $buf_read, %rsi
movq $BUF_LEN, %rdx
syscall

movq %rax, %r14
movq $buf_read, %r15
call szukaj

cmp $-1, %r9
je wyswietl_brak

movq %r9, %rax
movq $10, %rdx
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


wyswietl:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_write, %rsi
movq %rcx, %rdx
syscall
jmp koniec_programu

wyswietl_brak:
movq $0, %rcx
movb $'-', buf_write(,%rcx,1)
inc %rcx
movb $'1', buf_write(,%rcx,1)
inc %rcx
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_write, %rsi
movq %rcx, %rdx
syscall

koniec_programu:

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

szukaj:

movq $0, %rdi

szukaj_a:
movb (%r15,%rdi,1), %bl
dec %r14
inc %rdi
cmp $0, %r14
jle koniec
cmp $'a', %bl
jne szukaj_a

movb (%r15,%rdi,1), %bl
dec %r14
inc %rdi
cmp $0, %r14
jle koniec
cmp $'b', %bl
jne szukaj_a

movb (%r15,%rdi,1), %bl
dec %r14
inc %rdi
cmp $0, %r14
jle koniec
cmp $'c', %bl
jne szukaj_a

sub $2, %rdi
movq %rdi, %r9
ret

koniec:
movq $-1, %r9
ret
