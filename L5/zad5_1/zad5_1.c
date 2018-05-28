#include<stdio.h>
#include<stdlib.h>

extern int sprawdz();
extern int zmiana(int bit);
extern int dzielenie();

void dec2bin(int liczba){
	int tab[6] = {0,0,0,0,0,0};
	int i = 0;
	while(liczba != 0){
		tab[i] = liczba%2;
		liczba = liczba/2;
		i++;
	}
	for(i=5;i>=0;i--){
		printf("%d",tab[i]);
	}
	printf("\n");
}

int main(void){
	int opcja, bit_maski, cw, sw;
	do{	
		printf("---MENU---\n");
		printf("1. Sprawdz wystapienie wyjatku (sprawdz maske)\n");
		printf("2. Zmiana maski wyjatkow\n");
		printf("3. Dzielenie\n");
		printf("4. Koniec");
		scanf("%d",&opcja);
		system("@cls||clear");	
		switch(opcja){
			case 1:
				cw = sprawdz();				
				dec2bin(cw);
				break;		
			case 2:
				printf("Wprowadź bit maski (0-5)");				
				scanf("%d",&bit_maski);
				cw = zmiana(bit_maski);
				break;
			case 3:
				sw = dzielenie();
				printf("%d\n", sw);
				break;
		}
	}while(opcja != 4);
	return 0;
}


