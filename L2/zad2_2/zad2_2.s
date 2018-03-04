.data
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUF_LEN = 1024
plik_dane: .ascii "dane.txt\0"
plik_odp: .ascii "odp.txt\0"

.bss
.comm buf_dane_1, 1024
.comm buf_dane_2, 1024
.comm buf_wynik_ascii, 1027
.comm buf_hex_1, 513
.comm buf_hex_2, 513
.comm buf_wynik_hex, 513
.text
.globl _start

_start:
nop

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $buf_dane_1, %rsi
movq $BUF_LEN, %rdx
syscall

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $buf_dane_2, %rsi
movq $BUF_LEN, %rdx
syscall

movq %rax, %r8
movq %r8, %r14
#Wejście - kod szesnastkowy - pierwsza liczba
dec %r8
movq $513, %r9
petla_zamiana_hex_1:
dec %r8
dec %r9
movq $0, %rax
movb buf_dane_1(,%r8,1), %al

cmp $'A', %al
jge litera_1_1

sub $'0', %al
jmp petla_zamiana_dalej_1_1

litera_1_1:
sub $55, %al

petla_zamiana_dalej_1_1:
cmp $0, %r8
jle wpisz_1

movb %al, %bl
dec %r8
movb buf_dane_1(,%r8,1), %al

cmp $'A', %al
jge litera_2_1

sub $'0', %al
jmp petla_zamiana_dalej_2_1

litera_2_1:
sub $55, %al

petla_zamiana_dalej_2_1:
movb $16, %cl
mul %cl
add %bl, %al

wpisz_1:
movb %al, buf_hex_1(, %r9,1)
dec %r9
cmp $0, %r8
jg petla_zamiana_hex_1

movq %r14, %r8

#Wejście - kod szesnastkowy - druga liczba
dec %r8
movq $513, %r9
petla_zamiana_hex_2:
dec %r8
dec %r9
movq $0, %rax
movb buf_dane_2(,%r8,1), %al

cmp $'A', %al
jge litera_1_2

sub $'0', %al
jmp petla_zamiana_dalej_1_2

litera_1_2:
sub $55, %al

petla_zamiana_dalej_1_2:
cmp $0, %r8
jle wpisz_2

movb %al, %bl
dec %r8
movb buf_dane_2(,%r8,1), %al

cmp $'A', %al
jge litera_2_2

sub $'0', %al
jmp petla_zamiana_dalej_2_2

litera_2_2:
sub $55, %al

petla_zamiana_dalej_2_2:
movb $16, %cl
mul %cl
add %bl, %al

wpisz_2:
movb %al, buf_hex_2(, %r9,1)
dec %r9
cmp $0, %r8
jg petla_zamiana_hex_2


#Dodawanie
clc
pushfq
mov $512, %r8

petla_dodawanie:
movb buf_hex_1(,%r8,1), %al
movb buf_hex_2(,%r8,1), %bl
popfq
adc %bl, %al
pushfq
movb %al, buf_wynik_hex(,%r8,1)
dec %r8
cmp $0, %r8
jg petla_dodawanie

movq $512, %r8
movq $1025, %r9

zamiana_hex_ascii:
movb buf_wynik_hex(,%r8,1), %al
movb %al, %bl
movb %al, %cl
shr $4, %cl
movb $15, %bl
movb $15, %cl
add $'0', %bl
add $'0', %cl

cmp $'9', %bl
jle dalej_1
add $7, %bl

dalej_1:
cmp $'9', %cl
jle dalej_2
add $7, %bl

dalej_2:
movb %bl, buf_wynik_ascii(,%r9,1)
dec %r9
movb %cl, buf_wynik_ascii(,%r9,1)
dec %r9
dec %r8
cmp $0, %r8
jg zamiana_hex_ascii

movq $1026, %r8
movb $'\n', buf_wynik_ascii(,%r8,1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf_wynik_ascii, %rsi
movq $1027, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

