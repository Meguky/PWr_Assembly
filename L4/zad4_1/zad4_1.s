.data
D: .asciz "%d"
F: .asciz "%f"
LF: .asciz "%lf\n%lf"

.bss
.comm buf_liczba1, 4
.comm buf_liczba2, 4

.text
.global main
main:

movq $0, %rax
movq $F, %rdi
movq $buf_liczba1, %rsi
call scanf

movq $0, %rax
movq $D, %rdi
movq $buf_liczba2, %rsi
call scanf

movq $1, %rax
movq $0, %rdi
movq buf_liczba2(,%rdi,4), %rdi
movss buf_liczba1, %xmm0
call funkcja
movq %xmm0, %xmm1

movq $2, %rax
movq $LF, %rdi
sub $8, %rsp
call printf
add $8, %rsp

koniec:
movq $0, %rax
call exit
