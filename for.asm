;PUC-ECEC-CMP1057-ARQ1-
;12/02/19
;Wellington Junio De Melo Fernandes
;
;Segundo Programa for.asm


segment .data

	mens1 db"Digite alguma frase ",10,10
	tam1 equ $-mens1
	
segment .text

global _start

_start:

	mov edx,tam1 ;quantidade de caracteres, no caso ele imprime o tamanho armazenado em tamm
	mov ecx,mens1 ;ponteiro da string
	mov ebx,0 ;FD monitor
	mov eax,4 ;Serviço PRINT
	int 80h ;Kernel para executar serviço
	
	mov edx,100 ; maximo armazenado
	mov ecx,mens2 ; buffer destino
	mov ebx,1 ; FD=Teclado
	mov eax,3 ; serviço READ 
	int 80h
	; Em eax retorna o nº de caracteres armazenados
	
	mov ecx,eax ;Limite
	xor esi,esi ;Indice / ou esi =0

ini_for:
	
	mov al,[mens2+esi] ;car. origem
	mov [mens3+esi],al ;tran. destino
	inc esi ;incrementa esi++
	cmp esi,ecx ;Testa limite
	jb ini_for ; jb=jumpitbellow
	
	mov edx,ecx ;quantidade de caracteres, no caso ele imprime o tamanho armazenado em tamm
	mov ecx,mens3 ;ponteiro da string
	mov ebx,0 ;FD monitor
	mov eax,4 ;Serviço PRINT
	int 80h ;Kernel para executar serviço
	
segment .bss
	
	;dados nao inicializados
	mens2 resb 100	
	mens3 resb 100

segment .text ;Foi necessario dizer ao montador que o fim é participante do segmento .text(de codigo) ee não do segmento .bss
	
fim:
	
	mov eax,1 ; serviço EXIT
	int 80h ;encerra (mesmo kernel para executar.. esse é o padrão)
