;PUC-ECEC-CMP1057-ARQ1-
;30/04/19
;Wellington Junio De Melo Fernandes 
;
; filé.asm
segment .bss
	;dados nao inicializados
	opcao resb 100	
	senha resb 100
	
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
	
	erroab db "Erro na abertura do arquivo !!! |DEU RUIM|...Programa fechado",10,10
	tam equ $-erroab
	
	intro1 db "Digite a senha de super usuario para cadastrar uma pessoa ",10
	tamint equ $-intro1
	
	;descritor dd 0 ;variavel de dados
	fd resd 0
	
segment .text
global _start

_start:

	call openarq
	cmp eax,0	
	jl errorfile
	mov [fd],eax
	
	mov edx,limptam ;limpa a tela
	mov ecx,limpatela
	call printstr 
	call impmenu

	
;Procedure area
impmenu:

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
	jne impmenu
	
	call opera
	ret 
	
opera:

	mov al,[opcao]
	cmp al,"1"
	je acesso
	cmp al,"2"
	je administra
	cmp al,"3"
	je fim
	
	cmp al,"0"
	je impmenu
	cmp al,"4"
	jae impmenu
	ret
	
;Other Procedure
administra: ;falta validar senha do administrador e inserir nova senha em arquivo
	mov edx,tamint
	mov ecx,intro1
	call printstr
	
	mov edx,100
	mov ecx,senha
	call readstr
	cmp eax,7
	jne impmenu
	call valida
	cmp esi,6
	jne _start
	
	ret
	
;Other Procedure
valida:
	
	mov al,[senha+esi] ;car. origem 
	cmp al,"A" ; A C E
	jb opera
	cmp al,"Z"
	jg opera	
	inc esi 
	mov al,[senha+esi]
	cmp ax,"a" ; b d f
	jb opera
	cmp ax,"z"
	jg opera
	inc esi
	cmp esi,6
	jne valida
	
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
;criaarq:
	
	;mov ecx,0q777
	;mov ebx,arqname
	;mov eax,8
	;int 80h
	;ret

;Other Procedure
fechaarq:
		
	mov ebx,[fd]
	mov eax,6 ;serviço closefile
	int 80h
	ret
	
;Other Procedure
openarq:

	mov edx,777q
	mov ecx,2
	mov ebx,arqname
	mov eax,5
	int 80h
	ret
	
;Other Procedure / le o arquivo se a senha inserida for igual a primeira senha do arquivo
acesso:
	
	
	ret
	
;Other Procedure /coloca no arquivo
;cadastro:
	
	;call _start
	;ret
	
;Other Procedure
fim:
	call fechaarq
	mov eax,1 ; serviço EXIT
	int 80h ;encerra (mesmo kernel para executar.. esse é o padrão)
	ret
	
;Other Procedure em fase de teste
	 
	 ;cmp eax,0
	 ;jl errado
	 ;mov [fd],eax
	
errorfile:

	mov edx,tam
	mov ecx,erroab
	mov ebx,1 
	mov eax,4
	int 80h
	jmp fim
	ret
