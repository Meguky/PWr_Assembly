#include<stdio.h>

extern double log(int x, int kroki);

int main(void){
	int i;
	int kroki;
	print("Liczba: ");
	scanf("%d",&i);
	print("Kroki: ");
	scanf("%d",&i);
	print("Ln: ");
	printf("%lf",log(i));
}
