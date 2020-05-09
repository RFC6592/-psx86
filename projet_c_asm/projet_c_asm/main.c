/**
* @author EZZAYRI Sami | Groupe 2129
* @date 27-04-20
* Microprocesseurs notions avanc�es
*/

#include <stdio.h>

#define TAILLE 7



void affichage(void);
void clear(void);


/* Les prototypes */
extern int RetZeroInt();
extern double RetZeroDouble();
extern int SommeInt(int, int);
extern double SommeDouble(double, double);
extern void CopieOctet(char *, char);
extern void EchangeShort(short *, short *);
extern char *InitChaine(char *, char, int);
extern int RechercheVectShort(short *, short, int);

extern int Absolue(int);
extern double *ChangeSigne(double *);
extern int LoiOhm(int r, int i);
extern double PerimetreRectangle(double, double);
extern int TesterTriangleRect(int, int, int);
extern void ConversionFranc2Euro(double *pV);
extern float Moyenne(float *pV, int taille);

void main()
{
	clear();
	affichage();

	printf("\x1b[31m--> <Les fonctions pour aider a faire les exercices> <--\x1b[0m\n\n");
	// 0. RetZeroInt() && RetZeroDouble()
	printf("\x1b[32m[+]\x1b[0m RetZeroInt() =\x1b[33m %d\x1b[0m\n\x1b[32m[+]\x1b[0m RetZeroDouble() = \x1b[33m%.2lf\x1b[0m\n", RetZeroInt(), RetZeroDouble());
	// 1. SommeInt(int, int)
	printf("\x1b[32m[+]\x1b[0m SommeInt(3, 3) = %d \x1b[0m\n", SommeInt(3, 3));
	// 3. SommeDouble(double, double)
	printf("\x1b[32m[+]\x1b[0m SommeDouble(3, 3) = \x1b[33m%lf \x1b[0m\n", SommeDouble(3.0, 3.0));
	// 4. CopieOctet(char *, char)
	char b;
	CopieOctet(&b, 10);
	printf("\x1b[32m[+]\x1b[0m CopieOctet(&b, 10) : b = \x1b[33m%d \x1b[0m\n", b);
	// 5. EchangeShort(short *, short *)
	short s = 2, s1 = 5;
	EchangeShort(&s, &s1);
	printf("\x1b[32m[+]\x1b[0m EchangeShort(&s, &s1) => s = \x1b[33m%d\x1b[0m && s1 = \x1b[33m%d \x1b[0m\n", s, s1);
	// 6. InitChaine(char *, char, int)
	char msg[10];
	char car = 'S';
	int taille = 9;
	printf("\x1b[32m[+]\x1b[0m InitChaine(&msg[0], car, taille) = \x1b[33m%s \x1b[0m\n", InitChaine(&msg[0], car, taille));
	// 7. RechercheVectShort(short *, short, int)
	short vecteur[TAILLE] = { -2, 4, 26, 3, 200, 1, -6 };
	int position = RechercheVectShort(vecteur, 200, TAILLE);
	printf("\x1b[32m[+]\x1b[0m RechercheVectShort(vecteur, 200, TAILLE) : Position du chiffre = \x1b[33m%d \x1b[0m\n", position);

	// =======================================================================================================================================
	// =======================================================================================================================================
	// =======================================================================================================================================

	printf("\n\x1b[31m--> <Evaluation | Debut ligne 227> <--\x1b[0m\n\n");


	// 8. int Absolue(int i)
	int i1 = -5, i2 = 500, i3 = -78;
	printf("\x1b[32m[+]\x1b[0m Absolue(-5) = \x1B[7m\x1b[33m%d\x1b[0m ;; Absolue(500) = \x1B[7m\x1b[33m%d\x1b[0m ;; Absolue(-78) = \x1B[7m\x1b[33m%d \x1b[0m\n", Absolue(i1), Absolue(i2), Absolue(i3));


	// 9. double *ChangeSigne(double *pd)
	double val = -20.0;
	printf("\x1b[32m[+]\x1b[0m *ChangeSigne(&val) : Adresse = \x1B[7m\x1b[33m%p\x1b[0m <=> Valeur = \x1B[7m\x1b[33m%.2lf \x1b[0m\n", ChangeSigne(&val), *ChangeSigne(&val));


	// 10. int LoiOhm(int r, int i)
	int r = 25;
	int i = 9; // en Ampere
	printf("\x1b[32m[+]\x1b[0m LoiOhm(int r, int i) : Tension (U) = \x1B[7m\x1b[33m%d\x1b[0m\n", LoiOhm(r, i));


	// 11. double PerimetreRectangle(double longueur, double largeur)
	double longueur = 7.0;
	double largeur = 3.0; 
	printf("\x1b[32m[+]\x1b[0m PerimetreRectangle(double longueur, double largeur) : Perimetre (P) = \x1B[7m\x1b[33m%.2lf\x1b[0m\n", PerimetreRectangle(longueur, largeur));


	// 12. int TesterTriangleRect(int a, int b, int c);
	int coteA = 8;
	int coteB = 6;
	int coteC = 10;
	printf("\x1b[32m[+]\x1b[0m int TesterTriangleRect(int a, int b, int c) : Triangle Rectangle ? (1 pour Oui/0 pour Non) = \x1B[7m\x1b[33m%d\x1b[0m\n", TesterTriangleRect(coteA, coteB, coteC));


	// 12. void ConversionFranc2Euro(double *pV);
	double moneyEuro[20];
	ConversionFranc2Euro(&moneyEuro[0]);

	printf("\n\x1b[32m[+]\x1b[0m\x1b[7m\x1b[33m TABLE DE CONVERSION \x1b[33m\x1b[0m\n");
	printf("\x1b[31m\x1B[7mFRANCS\t\t EUROS\x1b[0m\n");
	for (int i = 1; i <= 20; ++i)
	{
		printf("%d \t\t %.3lf \n", i*5, moneyEuro[i-1]);
	}


	// 13. float Moyenne(float *pV, int taille);
	int taillevf = 7;
	float tabMoyenne[7] = {13.0, 15.0, 18.0, 19.0, 16.0, 14.0, 17.0};
	printf("\x1b[32m[+]\x1b[0m Moyenne(&tabMoyenne[0], taille) : Moyenne = \x1B[7m\x1b[33m%.2f\x1b[0m\n", Moyenne(tabMoyenne, taillevf));
}





void affichage()
{
	printf("\x1b[33m\t\t[Microprocesseurs notions avancees] Par EZZAYRI Sami \x1b[31m|\x1b[33m Groupe 2129 \x1b[0m\n\n");
}

void clear()
{
	#if defined(WIN32) && !defined(UNIX)
		system("cls");
	#elif defined(UNIX) && !defined(WIN32)
		system("clear");
	#else 
		system("clear");
		system("cls");
	#endif 
}

