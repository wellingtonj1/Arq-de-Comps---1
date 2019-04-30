;PUC-ECEC-CMP1057-ARQ1-
;30/04/19
;Wellington Junio De Melo Fernandes 
;
; filé.asm
segment .bss
	;dados nao inicializados
	opcao resb 100	
	mens5 resb 100
	
segment .data
	menu db "**-----------------------------------------------------------------------------",10
		  db "**		    		Choose a option	 ",10
		  db "** ( 1 ) access",10,"** ( 2 ) Register ",10,"** ( 3 ) Exit ",10,"** "
	tamenu equ $-menu
	
	limpatela db 27,"[H",27,"[J"
	limptam equ $-limpatela
	
	arqname db "arq.sen",0
	tamarqname equ $-arqname
	
	mens1 db "Digite o nome da pessoa"
	tammens1 equ $-mens1
	
	descritor dd 0
	
segment .text
global _start

_start:
	call criaarq
	
	mov edx,limptam ;limpa a tela
	mov ecx,limpatela
	call printstr
	
	mov edx,tamenu ; Imprime menu 
	mov ecx,menu ;ponteiro da string
	call printstr
	
	mov edx,100 ; maximo armazenado
	mov ecx,opcao ; disponibiliza o teclado para inserir opção
	call readstr; Em eax retorna o nº de caracteres armazenados
	cmp eax,2
	jne _start
	
	call opera
	
	call fim
	
;Procedure area
opera:

	mov al,[opcao]
	cmp al,"1"
	je acesso
	cmp al,"2"
	je cadastro
	cmp al,"3"
	je fim
	
	cmp al,"0"
	je _start
	cmp al,"4"
	jae _start
	ret
	
;Other Procedure
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
criaarq:
	
	mov ecx,0q777
	mov ebx,arqname
	mov eax,8
	int 80h

	ret

;Other Procedure
fechaarq:
	
	mov ebx,[descritor]
	mov eax,6

;Other Procedure
openarq:
	
	mov edx,0q777
	mov ecx,2
	mov ebx,arqname
	mov eax,5
	mov [descritor],eax
	int 80h

;Other Procedure / le o arquivo se a senha inserida for igual a qualquer uma do arquivo
acesso:
	
	ret
	
;Other Procedure /coloca no arquivo
cadastro:
	
	call openarq
	mov edx,tamenu
	mov ecx,menu
	mov ebx,[descritor]
	mov eax,3
	int 80h
	
	call fechaarq
	ret
	
;Other Procedure
fim:

	mov eax,1 ; serviço EXIT
	int 80h ;encerra (mesmo kernel para executar.. esse é o padrão)

	ret
	
