;PUC-ECEC-CMP1057-ARQ1-
;12/02/19
;Wellington Junio De Melo Fernandes
;
;Segundo Programa 3aula.asm


segment .data

	mens1 db"Digite uma senha de 6 caracteres intercalando maiuscula de minusculas: ",10
	tam1 equ $-mens1
	
	limpatela db 27,"[H",27,"[J"
	limptam equ $-limpatela
	
	mens3 db "Tenta advinhar a senha que foi digitada agora!",10
	tam3 equ $-mens3 
	
	mensacerto db"Vocẽ acertou !!!",10
	tamacerto equ $- mensacerto 

segment .text

global _start

_start:
	
	;limpa a tela
	mov edx,limptam
	mov ecx,limpatela
	call printstr
	
	mov edx,tam1 ;quantidade de caracteres, no caso ele imprime o tamanho armazenado em tamm
	mov ecx,mens1 ;ponteiro da string
	call printstr
	
	mov edx,7 ; maximo armazenado
	mov ecx,mens2 ; buffer destino
	call readstr; Em eax retorna o nº de caracteres armazenados
	call printstr
	cmp eax,7 ;Validando a quantidade de caracteres
	jne _start ;Se for < que 6 volta pro inicio
	
	mov ecx,eax ;limite
	xor esi,esi
	call valida
	cmp esi,6
	jne _start
		
tentativasenha:

	;limpa a tela
	mov edx,limptam
	mov ecx,limpatela
	call printstr
	
	mov edx,tam3 ;quantidade de caracteres, no caso ele imprime o tamanho armazenado em tamm
	mov ecx,mens3 ;ponteiro da string
	call printstr
	
	mov edx,100 ; maximo armazenado
	mov ecx,mens5 ; buffer destino
	call readstr;Em eax retorna o nº de caracteres armazenados
	xor esi,esi
	call comparaduas
	cmp esi,7
	jne tentativasenha
	call acerto
	
segment .bss
	
	;dados nao inicializados
	mens2 resb 100	
	mens5 resb 100

segment .text ;Foi necessario dizer ao montador que o fim é participante do segmento .text(de codigo) ee não do segmento .bss
	
fim:
	
	mov eax,1 ; serviço EXIT
	int 80h ;encerra (mesmo kernel para executar.. esse é o padrão)

;Procedure area
printstr:

	mov ebx,0
	mov eax,4
	int 80h
	ret
	
;Other Procedure
readstr:

	mov ebx,1
	mov eax,3
	int 80h
	ret
	
;Other Procedure
valida:

	mov al,[mens2+esi] ;car. origem 
	cmp al,"A" ; A C E
	jb sair
	cmp al,"Z"
	jg sair
	inc esi 
	mov al,[mens2+esi]
	cmp ax,"a" ; b d f
	jb sair
	cmp ax,"z"
	jg sair
	inc esi
	cmp esi,6
	jne valida
	
sair:
	ret
	
;Other Procedure
comparaduas:
	
	mov al,[mens2+esi]
	mov ah,[mens5+esi]
	cmp al,ah
	jne final
	inc esi
	cmp esi,7
	jne comparaduas
	
final:

	ret
	
;Other Procedure
acerto:
	
	mov edx,tamacerto
	mov ecx,mensacerto
	call printstr
	ret
	
