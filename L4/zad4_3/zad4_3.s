.data

.text

.global silnia
.type silnia, @function

silnia:

push %rbp
movq %rsp, %rbp

movq $0, %rcx
movq $1, %r8
movq $0, %r9

konwersja:
movb (%rdi,%rcx,1), %bl
sub $'0', %bl
inc %rcx

movq %rcx, %rax
mul %r8
movq %rax, %r8

movq %r8, %rax
mul %bl

add %rax, %r9


cmp %rsi, %rcx
jl konwersja

movq %r9, %rax

mov %rbp, %rsp
pop %rbp
ret
