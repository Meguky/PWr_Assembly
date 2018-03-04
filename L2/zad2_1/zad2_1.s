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
plik_dane: .ascii "dane.txt\0"
plik_odp: .ascii "odp.txt\0"

.bss
.comm buf_dane, 1024
.comm buf_hex, 528
.comm buf_oct, 1409
.text
.globl _start

_start:
nop

#Otworzenie pliku
movq $SYSOPEN, %rax
movq $plik_dane, %rdi
movq $FILE_READ, %rsi
movq $0, %rdx
syscall

movq %rax, %r15

#Zapisanie z pliku do bufora
movq $SYSREAD, %rax
movq %r15, %rdi
movq $buf_dane, %rsi
movq $BUF_LEN, %rdx
syscall

movq %rax, %r8

movq $SYSCLOSE, %rax
movq %r15, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

#Wejście - kod szesnastkowy
dec %r8
movq $528, %r9
petla_zamiana_hex:
dec %r8
dec %r9
movq $0, %rax
movb buf_dane(,%r8,1), %al

cmp $'A', %al
jge litera_1

sub $'0', %al
jmp petla_zamiana_dalej_1

litera_1:
sub $55, %al

petla_zamiana_dalej_1:
cmp $0, %r8
jle wpisz

movb %al, %bl
dec %r8
movb buf_dane(,%r8,1), %al

cmp $'A', %al
jge litera_2

sub $'0', %al
jmp petla_zamiana_dalej_2

litera_2:
sub $55, %al

petla_zamiana_dalej_2:
movb $16, %cl
mul %cl
add %bl, %al

wpisz:
movb %al, buf_hex(, %r9,1)
dec %r9
cmp $0, %r8
jg petla_zamiana_hex

#Zamiana na ósemkowy
movq $527, %r8
movq $1407, %r9
petla_zamiana_oct_1:
movq $0, %rax
sub $2, %r8
movb buf_hex(,%r8,1), %al
shl $8, %rax
inc %r8
movb buf_hex(,%r8,1), %al
shl $8, %rax
inc %r8
movb buf_hex(,%r8,1), %al
sub $3, %r8

movq $0, %r10

petla_zamiana_oct_2:
movb %al, %bl
and $7, %bl
add $'0', %bl
movb %bl, buf_oct(,%r9,1)
shr $3, %rax

dec %r9
inc %r10

cmp $8, %r10
jl petla_zamiana_oct_2

cmp $0, %r8
jg petla_zamiana_oct_1


movq $SYSOPEN, %rax
movq $plik_odp, %rdi
movq $FILE_WRITE, %rsi
movq $0644, %rdx
syscall

movq %rax, %r15

movq $1408, %r9
movb $'\n', buf_oct(,%r9,1)

movq $SYSWRITE, %rax
movq %r15, %rdi
movq $buf_oct, %rsi
movq $1409, %rdx
syscall

movq $SYSCLOSE, %rax
movq %r15, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

