.data
SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
FILE_READ = 0
FILE_WRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUF_LEN = 1024
plik_liczba_1: .ascii "liczba1.txt\0"
plik_liczba_2: .ascii "liczba2.txt\0"
plik_odp: .ascii "odp.txt\0"

.bss
.comm buf_liczba_1, 1024
.comm buf_liczba_2, 1024
.comm buf_hex_1, 512
.comm buf_hex_2, 512
.comm buf_wynik_hex, 512
.comm buf_wynik_ascii, 512

.text
.globl _start
_start:
nop

#Plik 1 start
movq $SYSOPEN, %rax
movq $plik_liczba_1, %rdi
movq $FILE_READ, %rsi
movq $0, %rdx
syscall

movq %rax, %r15

#Plik 1 do bufora
movq $SYSREAD, %rax
movq %r15, %rdi
movq $buf_liczba_1, %rsi
movq $BUF_LEN, %rdx
syscall

movq %rax, %r8

#Plik 1 koniec
movq $SYSCLOSE, %rax
movq %r15, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

#Plik 2 start
movq $SYSOPEN, %rax
movq $plik_liczba_2, %rdi
movq $FILE_READ, %rsi
movq $0, %rdx
syscall

movq %rax, %r15

#Plik 2 do bufora
movq $SYSREAD, %rax
movq %r15, %rdi
movq $buf_liczba_2, %rsi
movq $BUF_LEN, %rdx
syscall

movq %rax, %r9

#Plik 2 koniec
movq $SYSCLOSE, %rax
movq %r15, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

#zamiana łańcucha znaków liczba 1
dec %r8
movq $0, %r10
petla_zamiana_hex_1:
dec %r8
movb buf_liczba_1(,%r8,1), %al

cmp $'A', %al
jge litera_1_1

sub $'0', %al
jmp petla_zamiana_hex_1_1_dalej

litera_1_1:
sub $55, %al

petla_zamiana_hex_1_1_dalej:
cmp $0, %r8
jle wpisz_1

movb %al, %bl
dec %r8
movb buf_liczba_1(,%r8,1), %al

cmp $'A', %al
jge litera_1_2

sub $'0', %al
jmp petla_zamiana_1_2_dalej

litera_1_2:
sub $55, %al

petla_zamiana_1_2_dalej:
movb $16, %cl
mul %cl
add %bl, %al

wpisz_1:
movb %al, buf_hex_1(,%r10,1)
inc %r10
cmp $0, %r8
jg petla_zamiana_hex_1

#zamiana łańcucha znaków liczba 2
dec %r9
movq $0, %r11

petla_zamiana_hex_2:
dec %r9
movb buf_liczba_2(,%r9,1), %al

cmp $'A', %al
jge litera_2_1

sub $'0', %al
jmp petla_zamiana_2_1_dalej

litera_2_1:
sub $55, %al

petla_zamiana_2_1_dalej:
cmp $0, %r9
jle wpisz_2

movb %al, %bl
dec %r9
movb buf_liczba_2(,%r9,1), %al

cmp $'A', %al
jge litera_2_2

sub $'0', %al
jmp petla_zamiana_2_2_dalej

litera_2_2:
sub $55, %al

petla_zamiana_2_2_dalej:
movb $16, %cl
mul %cl
add %bl, %al

wpisz_2:
movb %al, buf_hex_2(,%r11,1)
inc %r11
cmp $0, %r9
jg petla_zamiana_hex_2

#dodawanie
clc
pushf
movq $0, %r8
petla_dodawanie:
movb buf_hex_1(,%r8,1), %al
movb buf_hex_2(,%r8,1), %bl
popf
adc %bl, %al
pushf
movb %al, buf_wynik_hex(,%r8,1)
inc %r8
cmp $512, %r8
jl petla_dodawanie

movq $1, %r8
movq $0, %r9
zamiana_ascii:
movq $0, %rax
inc %r8
movb buf_wynik_hex(,%r8,1), %al
shr $8, %rax
dec %r8
movb buf_wynik_hex(,%r8,1), %al
add $2, %r8

movq $0, %r10

zamiana_ascii_2:
movb %al, %bl
and $3, %bl
add $'0', %bl
movb %bl, buf_wynik_ascii(,%r9,1)
shr $2, %rax

inc %r9
inc %r10

cmp $4, %r10
jl zamiana_ascii_2

cmp $511, %r8
jl zamiana_ascii

movq $SYSOPEN, %rax
movq $plik_odp, %rdi
movq $FILE_WRITE, %rsi
movq $0644, %rdx
syscall

movq %rax, %r8

movq $SYSWRITE, %rax
movq %r8, %rdi
movq $buf_wynik_ascii, %rsi
movq $512, %rdx
syscall

movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
