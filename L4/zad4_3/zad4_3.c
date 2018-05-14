#include<stdio.h>

extern int silnia(char * liczba, int len);

int main(void){
	printf("Wynik: %d", silnia("1111",4));
	return 0;
}
