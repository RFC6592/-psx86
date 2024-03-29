.MODEL FLAT, C 
.DATA

	dtmp DQ  0.0
	dtmpPerimetre DQ 2.0
	dtmpMax DQ 5.0
	dtmpMin DQ 100.0

	nullByte DB 0
	emptySpace DB 20h

	compteur DD 0
	euro DQ 0.125
	dtmpFive DQ 5.0

	fdiviseur DD 7.0
.CODE 




; Fonction qui retourne 0
; Prototype en C : int RetZeroInt()
; Retour: la valeur 0 (type int)

RetZeroInt PROC
	mov eax, 0

	ret
RetZeroInt ENDP




; Fonction qui retourne 0
; Prototype: double RetZeroDouble()
; Retour: la valeur 0 (type double)

RetZeroDouble PROC
	fld dtmp

	ret
RetZeroDouble ENDP




; Fonction qui retourne la somme
; Prototype : int SommeInt(int i1, int i2)
; Retour : la somme des deux parametres

SommeInt PROC
	i2 EQU <DWORD PTR [EBP + 12]> 
	i1 EQU <DWORD PTR [EBP + 8]>

	push ebp
	mov ebp, esp

	mov eax, i1
	add eax, i2

	pop ebp

	ret
SommeInt ENDP




; Fonction qui retourne la somme en double
; Prototype : double SommeDouble(double d1, double d2)
; Retour : la somme des deux parametres

SommeDouble PROC
	d2 EQU <QWORD PTR [EBP + 16]> 
	d1 EQU <QWORD PTR [EBP + 8]>
	d EQU <QWORD PTR [EBP - 8]> ; Identificateur local attribue a la variable locale creee dans cette fonction

	push ebp ; Creation d'un nouveau sommet ou on place la valeur de ebp au sommet de la pile (8octets)
	mov ebp, esp
	sub esp, 8 ; Creation de la variable locale d de 8 octets

	movsd xmm0, d1
	addsd xmm0, d2
	movsd d, xmm0

	fld d ; Transmission du contenu de la variable locale a la FPU

	add esp, 8 ; Suppression de la variable locale d
	pop ebp

	ret ; Recuperation de l'adresse de retour au code et place dans EIP (instruction pointer) la prochaine instruction
SommeDouble ENDP




; Fonction qui copie une valeur d'un octet dans une variable
; Prototype en C : void CopieOctet(char *pb, cha b)
; Parametres : pb = l'adresse de la variable du type char
;			   b = la valeur a copier
; Retour : aucun
; Information : Les processeurs Intel sont dits "little endians" => les octets des valeurs sur plusieurs octets sont inverses en memoire ! (P�37)

CopieOctet PROC
	pb EQU <DWORD PTR [EBP + 8]>
	b EQU <BYTE PTR [EBP + 12]> ; la valeur est empilee

	push ebp ; Creation d'un nouveau sommet (4octets)
	mov ebp, esp

	mov al, b ; al = 8bits
	mov ebx, pb
	mov BYTE PTR [ebx], al

	pop ebp 

	ret ; Recuperation de l'adresse de retour au code et place dans EIP la prochaine instruction

CopieOctet ENDP




; Fonction qui echange 2 valeurs du type short
; Prototype en c : void EchangeShort(short *ps, short *ps1);
; Parametres : ps = l'adresse de la variable stockant le 1er short
;			   ps1 = l'adresse de la variable stockant le 2e short
; Retour : aucun

EchangeShort PROC
	ps EQU <DWORD PTR [EBP + 8]>
	ps1 EQU <DWORD PTR [EBP + 12]>

	push ebp
	mov ebp, esp

	; Il faut utiliser deux autres registres (ecx, edx)
	mov eax, ps
	mov cx, WORD PTR [eax]
	mov ebx, ps1
	mov dx, WORD PTR [ebx]

	mov WORD PTR [eax], dx
	mov WORD PTR [ebx], cx

	pop ebp

	ret

EchangeShort ENDP




; Fonction qui duplique un caractere dans une chaine
; Prototype en C : char *InitChaine(char *pChaine, char car, int taille)
; Parametres : pChaine = l'adresse de debut de la chaine
;			   car = le caractere a dupliquer
;              taille = la taille de la chaine
; Retour : l'adresse de debut de la chaine

InitChaine PROC
	pChaine EQU <DWORD PTR [EBP + 8]>
	car EQU <BYTE PTR [EBP + 12]>
	taille EQU <DWORD PTR [EBP + 16]>

	push ebp
	mov ebp, esp

	mov ecx, pChaine
	mov esi, 0

	debutboucle:
		cmp esi, taille
		je finboucle

		mov al, car ; al = 8 bits comme le caractere est un type char
		mov BYTE PTR [ecx + esi], al
		inc esi

		jmp debutboucle

	finboucle:
		mov byte ptr [ecx + esi], 0
		mov eax, pChaine

		pop ebp ; Recupere de la pile le contenu initial de EBP
		ret


InitChaine ENDP




; Fonction qui recherche une valeur dans un vecteur de type short
; Prototype en C : void RechercheVectShort(short *pV, short s, int taille)
; Parametres : pV = l'adresse du vecteur de cellules du type short
;              s = la valeur a rechercher
;              taille = le nombre de cellules du vecteur
; Retour : la position de la valeur si elle est presente, sinon -1

RechercheVectShort PROC
	pV EQU <DWORD PTR [EBP + 8]>
	s EQU <WORD PTR [EBP + 12]>
	taille EQU <DWORD PTR [EBP + 16]>

	push ebp
	mov ebp, esp

	mov ebx, pV
	mov eax, 0
	mov cx, s

	debutboucle:
		cmp eax, taille
		je finboucle

		cmp WORD PTR [ebx + eax * 2], cx ; C'est *2 parceque c'est un type short
		je nbtrouve

		inc eax

		jmp debutboucle

	nbtrouve:
		pop ebp
		ret
	finboucle:
		mov eax, -1

RechercheVectShort ENDP




; @brief Fonction qui se charge de retourner la valeur absolue d'une variable du type int
; @prototype Prototype en C : int Absolue(int i);
; @param i = la valeur � retourner en valeur absolue
; @Return retourne la valeur absolue 

Absolue PROC
	i EQU <DWORD PTR [EBP + 8]>

	push ebp
	mov ebp, esp

	mov eax, i

	; ======================= TRAITEMENT =======================

	cdq ; (Convert DoubleWord to QuadWord) Etendre le bit de signe d'EAX dans le registre EDX : SI c'est un nombre positif alors EDX = 0x00000000 SINON EDX = 0xFFFFFFFF, SF = 1
	xor eax, edx ; SI c'est un nombre positif �a change rien 
	sub eax, edx ; SI EDX = 0xFFFFFFFF(0d = -1) ALORS eax - 1

	pop ebp
	ret

Absolue ENDP




; @brief Fonction qui se charge de changer le signe de la valeur de la variable du type double
; https://fr.wikibooks.org/wiki/Fonctionnement_d%27un_ordinateur/Un_exemple_de_jeu_d%27instruction_:_l%27extension_x87
; https://pierre.maurette.fr/assembleur/livres/4061/chap08_fpu
; https://cs.fit.edu/~mmahoney/cse3101/float.html
; @prototype Prototype en C : double *ChangeSigne(double *pd);
; @param *pd = l'adresse de la variable
; @Return retourne l'adresse de la variable

ChangeSigne PROC
	pd	EQU <DWORD PTR [EBP + 8]> ; l'adresse de la variable donnee en argument de la fonction
	tmp	EQU <QWORD PTR [EBP - 8]> ; une variable locale tmp

	push ebp ; Creation d'un nouveau sommet ou nous allons placer la valeur de EBP au sommet de la pile (8 octets)
	mov ebp, esp
	sub esp, 8 ; Creation d'un nouveau sommet pour notre variable tmp

	; ======================= TRAITEMENT =======================
	mov eax, pd
	movsd xmm0, QWORD PTR [eax] 

	movsd tmp, xmm0

	fld tmp 
	fchs ; Instruction qui nous permet de changer de signe de ST
	fst QWORD PTR [eax] ; Copie un r�el de ST vers un autre registre ou la m�moire. 

	; ======================= FIN TRAITEMENT =======================
	mov eax, pd ; On va mettre l'adresse de pd dans le registre 32bits EAX


	add esp, 8 ; On va supprimer la variable locale
	pop ebp
	ret

ChangeSigne ENDP




; @brief Fonction qui se charge d'appliquer la formule de la loi d'Ohm afin de trouver la tension U
; @prototype Prototype en C : int LoiOhm(int r, int i);
; @param r = la resistance
; @param i = l'intensite
; @Return retourne la tension (U)

LoiOhm PROC
	intensite	EQU <DWORD PTR [EBP + 8]>
	resistance	EQU <DWORD PTR [EBP + 12]>

	push ebp
	mov ebp, esp

	; ======================= TRAITEMENT =======================
	mov eax, resistance
	mov ecx, intensite

	imul eax, ecx ; U = R x I

	pop ebp
	ret

LoiOhm ENDP




; @brief Fonction qui se charge de calculer le perimetre d'un rectangle.
; @prototype Prototype en C : double PerimetreRectangle(double longueur, double largeur);
; @param largeur = la largeur du rectangle (que l'on note l)
; @param longueur = la longueur du rectangle (que l'on note L)
; @Return retourne le perimetre du rectangle (Formule : P = (L + l) � 2)

PerimetreRectangle PROC
	largeur		EQU <QWORD PTR [EBP + 16]>
	longueur	EQU <QWORD PTR [EBP + 8]>
	resultat	EQU <QWORD PTR [EBP - 8]> ; Identificateur local attribue a la variable locale creee dans cette fonction

	push ebp
	mov ebp, esp
	sub esp, 8 ; Creation d'un nouveau sommet

	; ======================= TRAITEMENT =======================
	movsd xmm0, longueur
	movsd xmm1, largeur
	addsd xmm0, xmm1 ; (L + l)
	
	movsd xmm2, dtmpPerimetre ; On va mettre 2.0 dans le registre 128bits xmm1

	mulsd xmm0, xmm2 ;  (L + l) � 2
	movsd resultat, xmm0

	; ======================= FIN TRAITEMENT =======================
	fld resultat ; Le resultat est stocke dans tmp


	add esp, 8 ; On va supprimer la variable locale
	pop ebp
	ret

PerimetreRectangle ENDP




; @brief Fonction qui se charge de savoir si un triangle est rectangle ou pas (Th�or�me de pythagore)
; @prototype Prototype en C : int TesterTriangleRect(int a, int b, int c);
; @param a = cote a du triangle
; @param b = cote b du triangle
; @param c = cote c du triangle
; @Return retourne 1 si le triangle est rectangle et 0 dans le cas contraire (Formule : c� = a� + b �)

TesterTriangleRect PROC
	coteC EQU <DWORD PTR [EBP + 16]>
	coteB EQU <DWORD PTR [EBP + 12]>
	coteA EQU <DWORD PTR [EBP + 8]>

	push ebp
	mov ebp, esp
	
	; ======================= TRAITEMENT =======================
	mov edx, coteC
	imul edx, coteC ; c�

	mov eax, coteA
	imul eax, coteA ; a�

	mov ecx, coteB 
	imul ecx, coteB ; b�

	add eax, ecx ; eax = a� +  b�

	; ======================= COMPARAISON  =======================
	cmp edx, eax 
	je estTriangleRectangle
	jne estPasTriangleRectangle
	
	; ======================= FIN TRAITEMENT =======================

	estTriangleRectangle:
		mov eax, 1 
		jmp finfonction
	estPasTriangleRectangle:
		mov eax, 0
		jmp finfonction

	finfonction:
		pop ebp
		ret

TesterTriangleRect ENDP


; @brief Fonction qui se charge de convertir des francs belge en euros allant de 5 � 100 francs par pas de +5
; @prototype Prototype en C : void ConversionFranc2Euro(double *pV);
; @param pV = vecteur de double

ConversionFranc2Euro PROC
	vecteur EQU <DWORD PTR [EBP + 8]> ; Contient l'adresse

	push ebp
	mov ebp, esp

	;  ======================= DECLARATION DES VARIABLES =======================
	mov eax, vecteur ; eax contient l'adresse du vecteur
	mov ecx, compteur ; ecx = 0
	movsd xmm1, dtmpFive ; xmm1 = 5

	;  ======================= TRAITEMENT =======================

	debutwhile:
		cmp ecx, 20
		jl blocwhile
		jnl finwhile
	blocwhile:
		
		movsd xmm0, euro ; xmm0 = 0.125 sachant que 5 francs = 0.125 euros
		mulsd xmm0, xmm1 ; xmm0 = 0.125 * 5.0 etc
		divsd xmm0, dtmpFive ; xmm0 = 0.125 * 5.0 / 5.0 (regle de 3)

		movsd QWORD PTR [eax + ecx * 8], xmm0
		add ecx, 1
		addsd xmm1, dtmpFive

		jmp debutwhile

	finwhile:
		pop ebp
		ret

ConversionFranc2Euro ENDP




; @brief Fonction qui se charge de retourner la moyenne arithmetique des valeurs d'un vecteur du type float
; @prototype Prototype en C : float Moyenne(float *pV, int taille);
; @param pV = vecteur de type float
; @param taille = taille du vecteur
; @Return retourne la moyenne arithmetique

Moyenne PROC
	vecteur		EQU <DWORD PTR [EBP + 8]>
	tailleV		EQU <DWORD PTR [EBP + 12]>
	ftmp		EQU <DWORD PTR [EBP - 8]>

	push ebp
	mov ebp, esp
	sub esp, 4

	;  ======================= DECLARATION DES VARIABLES =======================
	mov esi, vecteur
	mov ecx, compteur
	movsd xmm0, dtmp
	;  ======================= TRAITEMENT =======================
	debutwhile:
		cmp ecx, tailleV
		jl blocwhile
		jnl finwhile

	blocwhile:
		addss xmm0, DWORD PTR [esi + ecx * 4]
		add ecx, 1 ; compteur++
		jmp debutwhile

	finwhile:
		divss xmm0, fdiviseur ; xmm0 = 112.0 / 7.0
		movss ftmp, xmm0 ; ftmp = 16.0

		fld ftmp ; ; Transmission du contenu de la variable locale a la FPU
		add esp, 4
		pop ebp
		ret


Moyenne ENDP




; @brief Fonction qui se charge de copier dans un vecteur de type short le contenu d'un vecteur de type double
; @prototype Prototype en C : void CopierVecteur(short *pVCible, double *pVSource, int taille);
; @param pVCible = vecteur de type short (tableau source)
; @param pVSource = vecteur de type double (tableau destination)
; @param taille = taille tableau

CopierVecteur PROC
	vecteurDestination  EQU <DWORD PTR [EBP + 8]> ; Vecteur de type short 
	vecteurSource		EQU <DWORD PTR [EBP + 12]> ; Vecteur de type double
	taille				EQU <DWORD PTR [EBP + 16]>

	push ebp
	mov ebp, esp

	;  ======================= DECLARATION DES VARIABLES =======================
	mov edi, vecteurDestination ; Vecteur de type short 
	mov esi, vecteurSource ; Vecteur de type double
	xor ecx, ecx ; compteur => ecx = 0

	;  ======================= TRAITEMENT =======================
	debutwhile:
		cmp ecx, taille
		jl blocwhile
		jnl finwhile 
	blocwhile:
		movsd xmm0, QWORD PTR [esi + ecx * 8]
		cvtsd2si eax, xmm0 ; Conversion double vers short (16bits)
		mov WORD PTR [edi + ecx * 2], ax

		add ecx, 1 ; compteur++
		jmp debutwhile
	finwhile:
		pop ebp
		ret

CopierVecteur ENDP




; @brief Fonction qui se charge de retourner 1 si une lettre donnee n'est pas pr�sente dans une chaine et qui retourne 0 dans le cas contraire
; @prototype Prototype en C : int TesterNonPresence(char *pChaine, char lettre);
; @param pChaine = vecteur de type short (tableau source)
; @param lettre = vecteur de type double (tableau destination)
; @return retourner 1 si une lettre donnee n'est pas presente dans une chaine et qui retourne 0 dans le cas contraire

TesterNonPresence PROC
	vecteur EQU <DWORD PTR [EBP + 8]>
	lettre EQU <BYTE PTR [EBP + 12]>

	push ebp
	mov ebp, esp

	mov esi, vecteur
	mov bl, lettre
	xor ecx, ecx ; compteur = 0

	;  ======================= TRAITEMENT =======================
	debutwhile:
		mov dl, BYTE PTR [esi + ecx * 1] ; dl (8bits) contient une lettre
		cmp dl, nullByte
		jne blocwhile
		jmp finwhile 
	blocwhile:
		add ecx, 1 ; compteur++
		cmp dl, bl ; On compare les deux lettres
		je trouve
		jne debutwhile

	trouve:
		mov eax, 0
		pop ebp
		ret

	finwhile:
		mov eax, 1
		pop ebp
		ret

TesterNonPresence ENDP




; @brief Fonction qui se charge de mettre en minuscules une lettre sur 2 dans une chaine
; @prototype Prototype en C : char *Minuscules(char *pChaine);
; @param pChaine = la chaine (Exemple : "LE GRAND ZORRO")
; @return retourne l'adresse de la chaine

Minuscules PROC
	chaine	 EQU <DWORD PTR [EBP + 8]>
	tmp		 EQU <DWORD PTR [EBP - 8]>

	push ebp
	mov ebp, esp
	sub esp, 4

	;  ======================= DECLARATION DES VARIABLES =======================
	mov esi, chaine
	xor eax, eax ; notre compteur = 0
	mov ecx, 2 ; notre diviseur

	;  ======================= TRAITEMENT =======================
	debutwhile:
		mov bl, BYTE PTR [esi + eax * 1] ; bl (8bits) contient une lettre de la chaine
		cmp bl, nullByte ; while (bl != '\0') 
		jne blocwhile
		jmp finwhile 
		;lE gRaNd ZoRrO"
	blocwhile:
		cmp bl, 20h ; if (bl == ' ') 
		je blocIf
		jne blocElse

	blocif:
		add eax, 1 ; compteur++;
		jmp debutwhile 

	blocElse:
		cdq ; Etendre

		mov tmp, eax ; On sauvegarde la position de notre "curseur" (l'endroit ou on se trouve dans la chaine pour l'instant) dans une variable tmp
		idiv ecx ; Info : edx = eax % 2 && eax = eax / 2
		mov eax, tmp 

		add eax, 1 ; compteur++
		cmp edx, 0 ; if ( (eax % 2) == 0)

		jne debutwhile
		je miseEnMinuscule
		
	miseEnMinuscule:
		add bl, 32 ; mise en minuscule (+32)
		mov BYTE PTR [esi + eax - 1 * 1], bl ; On modifie la lettre qui dans notre chaine. Exemple : 'A' => 'a'
		jmp debutwhile

	finwhile:
		mov eax, chaine
		add esp, 4
		pop ebp
		ret

Minuscules ENDP




; @brief Fonction qui se charge de savoir si une chaine est un palindrome
; @prototype Prototype en C : int TesterPalindrome(char *pChaine);
; @param pChaine = la chaine (Exemple : "radar")
; @return retourne 1 si c'est un palindrome et 0 dans le cas contraire

TesterPalindrome PROC
	chaine EQU <DWORD PTR [EBP + 8]>
	taille EQU <DWORD PTR [EBP + 12]>

	push ebp
	mov ebp, esp

	;  ======================= DECLARATION DES VARIABLES =======================
	mov esi, chaine
	xor ecx, ecx ; ecx = 0
	sub esp, 4

	;  ======================= TRAITEMENT 1 : Recuperation de la longueur de la chaine =======================
	strlen:
		mov bl, BYTE PTR [esi + ecx * 1]
		cmp bl, nullByte ; while (bl != '\0')
		jne blocstrlen
		je finblocstrlen
	blocstrlen:
		add ecx, 1
		jmp strlen

	finblocstrlen:
		mov taille, ecx
		xor ecx, ecx ; ecx = 0


	;  ======================= TRAITEMENT 1 : Verification pour savoir si la chaine est un palindrome =======================

	mov edi, taille ; EDI contient la longueur de la chaine 

	debutwhile:
		mov bl, BYTE PTR [esi + ecx * 1] ; bl (8bits) va contenir au debut la premiere lettre de la chaine
		mov dl, BYTE PTR [esi + edi - 1 * 1] ; dl (8bits) va contenir au debut la derniere lettre de la chaine
		cmp bl, nullByte ; while (bl != '\0' )

		jne blocwhile
		je finwhile


	blocwhile:
		cmp bl, dl ; if ( bl == dl ) 
		je incrementationDecrementation

		mov eax, 0 ; else { return 0; }
		jmp finwhile

	incrementationDecrementation:
		sub edi, 1 ; edi--
		add ecx, 1 ; ecx++
		jmp debutwhile

	finwhile:
		add esp, 4
		pop ebp
		ret

TesterPalindrome ENDP


END