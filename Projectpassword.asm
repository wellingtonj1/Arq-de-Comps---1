;PUC-ECEC-CMP1057-ARQ1-
;23/04/19
;Wellington Junio De Melo Fernandes 
;
; pjsenha.asm
segment .bss
	;dados nao inicializados
	opcao resb 100	
	mens5 resb 100
	
segment .data
	menu db "**-----------------------------------------------------------------------------",10
		  db "**		    		Choose a option	 ",10
		  db "** ( 1 ) Acessar",10,"** ( 2 ) Cadastrar ",10,"** ( 3 ) Sair ",10,"** "
	tamenu equ $-menu
	
	limpatela db 27,"[H",27,"[J"
	limptam equ $-limpatela
	
	mens1 db "Digite o nome da pessoa"
	
	
segment .text
global _start

_start:
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
	
;Procedure area
opera:

	mov al,[opcao]
	cmp al,"1"
	je acesso
	cmp al,"2"
	je cadastro
	cmp al,"3"
	je sair
	
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
acesso:
	
	ret
	
;Other Procedure
cadastro:

	ret
	
;Other Procedure
sair:

	mov eax,1 ; serviço EXIT
	int 80h ;encerra (mesmo kernel para executar.. esse é o padrão)

	ret
	
