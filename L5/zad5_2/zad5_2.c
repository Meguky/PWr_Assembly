#include<stdio.h>

extern double logarytm(double liczba, int kroki);

int main(void){
	float i;
	int kroki;
	printf("Liczba: ");
	scanf("%f",&i);
	printf("Kroki: ");
	scanf("%d",&kroki);
	printf("Ln: ");
	printf("%lf",logarytm(i,kroki));
}
