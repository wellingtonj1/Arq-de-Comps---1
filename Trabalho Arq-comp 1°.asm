
;PUC-ECEC-CMP1057-ARQ1-
;30/04/19
;Wellington Junio De Melo Fernandes 
;
; filé.asm
%define BUF_SIZE 256

segment .bss
	;dados nao inicializados
	opcao resb 100	
	senha resb 100
	poearq resb 100
	fd_in resd 1
	fd_out resd 1
	in_buf resb BUF_SIZE 
	
segment .data
	
	menu db "**-----------------------------------------------------------------------------",10
		  db "**		    		Choose a option	 ",10
		  db "** ( 1 ) access",10,"** ( 2 ) Register ",10,"** ( 3 ) Exit ",10,"** "
	tamenu equ $-menu
	
	limpatela db 27,"[H",27,"[J"
	limptam equ $-limpatela
	
	in_file_name db "arq.sen",0
	tamarqname equ $-in_file_name
	
	mens1 db "Digite o nome da pessoa"
	tammens1 equ $-mens1
	
	erroab db "Erro na abertura do arquivo !!! |DEU RUIM|...Programa fechado",10,10
	tam equ $-erroab
	
	intro1 db "Digite a senha de super usuario para cadastrar uma pessoa ",10
	tamint equ $-intro1
	
	erro db "Erro aqui nessa posição",10,10
	tamerro equ $-erro
	;descritor dd 0 ;variavel de dados
	
	
segment .text
global _start

_start:

	call openarq
	mov [fd_in],eax
	cmp eax,0	
	jl errorfile
	
	call poeinicio
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
administra: ;falta inserir nova senha em arquivo
	mov edx,tamint
	mov ecx,intro1
	call printstr
	
	mov edx,100
	mov ecx,senha
	call readstr
	cmp eax,7
	jne impmenu
	xor esi,esi
	call valida
	cmp esi,6
	jne _start
	xor esi,esi
	call compara
	cmp esi,6
	jne fim
	mov edx,100
	mov ecx,poearq
	call escrevearq
	
	ret
	
;Other Procedure
valida:
		
	mov al,[senha+esi] ;car. origem 
	cmp al,"A" ; A C E
	jb impmenu
	cmp al,"Z"
	jg impmenu	
	inc esi 
	mov al,[senha+esi]
	cmp ax,"a" ; b d f
	jb impmenu
	cmp ax,"z"
	jg impmenu
	inc esi
	cmp esi,6
	jne valida
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
;criaarq:
	
	;mov ecx,0q777
	;mov ebx,arqname
	;mov eax,8
	;int 80h
	;ret

;Other Procedure
fechaarq:
		
	mov ebx,[fd_in]
	mov eax,6 ;serviço closefile
	int 80h
	ret
	
;Other Procedure
openarq:

	mov edx,0700
	mov ecx,2
	mov ebx,in_file_name
	mov eax,5
	int 80h
	ret
	
;Other Procedure / le o arquivo se a senha inserida for igual a primeira senha do arquivo
acesso:
	
	
	ret
	
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
	
;Other Procedure
errorfile:

	mov edx,tam
	mov ecx,erroab
	mov ebx,1 
	mov eax,4
	int 80h
	jmp fim
	ret

;Other Procedure
repeat_read:

	;read input file
	mov edx,BUF_SIZE
	mov ecx,in_buf
	mov ebx,[fd_in]
	mov eax,3
	int 80h

	;write to output file
	mov ecx,in_buf
	mov ebx,[fd_out]
	mov eax,4
	mov edx,eax
	int 80h
	cmp edx,BUF_SIZE
	jl copy_done
	jmp repeat_read
	
	ret

;Other Procedure
copy_done:
	
	mov ebx,[fd_out]
	mov eax,6
	ret
	
compara:
	
	mov al,[senha+esi]
	mov ah,[fd_in+esi]
	cmp al,ah
	jne errototal
	cmp esi,7
	jne compara
	ret

escrevearq:

	mov eax,4
	mov edx,eax
	int 80h
	ret

errototal:
	
	mov edx,tamerro
	mov ecx,erro
	call printstr
	ret

poeinicio:

	mov edx,0
	mov ecx,0
	mov ebx,[fd_in]
	mov eax,19
	ret
