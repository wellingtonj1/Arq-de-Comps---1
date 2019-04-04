;PUC-ECEC-CMP1057-ARQ1-
;12/02/19
;Wellington Junio De Melo Fernandes
;
;Segundo Programa 3aula.asm


segment .data

	mens1 db"Digite uma senha de 6 caracteres intercalando maiuscula de minusculas: ",10
	tam1 equ $-mens1
	
	limpatela db 27,"[H]",27,"[j]"
	limptam equ $-limpatela
	
	mens3 db "Tenta advinhar a senha que foi digitada agora!",10
	tam3 equ $-mens3 

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
	
	mov edx,100 ; maximo armazenado
	mov ecx,mens2 ; buffer destino
	call readstr; Em eax retorna o nº de caracteres armazenados
	
	cmp eax,7 ;Validando a quantidade de caracteres
	jne _start ;Se for < que 6 volta pro inicio
	
	mov ecx,eax ;limite
	call valida
	cmp esi,6
	jne _start
		
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

	xor esi,esi
	
init_for:

	mov al,[mens2+esi] ;car. origem
	cmp al, 'A'
	jb sair
	cmp al,'Z'
	jb sair
	inc esi
	cmp al,'a'
	jb sair
	cmp al,'z'
	jb sair
	inc esi
	cmp esi,6
	jne init_for
	
sair:
	ret
	
	
	
	
	
	
	
