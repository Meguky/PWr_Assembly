#include<stdio.h>

char liczba[] = "12";
int len = 6;
long wynik = 0;

int main(void){
	
	asm(
	"movq $0, %%r8 \n"
	"movq $1, %%r9 \n"
	"movq $6, %%rcx \n"
	"petla: \n"
	"dec %%rcx \n"
	"movb (%0,%%rcx,1), %%bl \n"
	"sub $'0', %%bl \n"
	"movq %%r9, %%rax \n"	
	"mul %%bl \n"
	"add %%rax, %%r8 \n"
	"movq $7, %%rax \n"
	"mul %%r9 \n"
	"movq %%rax, %%r9 \n"
	"cmp $-1, %%rcx \n"
	"jg petla \n"
	"movq %%r8, %0 \n"
	:"=r"(wynik)
	:"r"(&liczba)
	:"%rax","%rbx","%rcx","%r8","%r9"
	);

	printf("%ld",wynik);
	return 0;
}
