
;PUC-ECEC-CMP1057-ARQ1-
;30/04/19
;Wellington Junio De Melo Fernandes 
;
; filé.asm
%define BUF_SIZE 256

segment .bss
	;dados nao inicializados
	opcao resb 100	
	senha resb 7
	poearq resb 7
	pegaarq resb 10
	fd_in resd 1
	fd_out resd 1
	in_buf resb BUF_SIZE 
	auxerro resb 100
	auxsenha resb 100
	
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
	
	erro db "pressione enter para continuar !",10,10
	tamerro equ $-erro

	mendigita db "Digite agora a nova senha",10
	tamdigita equ $-mendigita
	;descritor dd 0 ;variavel de dados

	mensucess db "Sucesso, o usuario é cadastrado no sistema ! Tecle enter para continuar",10,10
	tamsucess equ $-mensucess

	inst db "Insira a senha para verificar se a mesma existe.",10,10
	taminst equ $-inst
	
	
segment .text
global _start

_start:

	call openarq
	mov [fd_in],eax
	cmp eax,0	
	jl errorfile
	
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
administra:

	mov edx,tamint
	mov ecx,intro1
	call printstr
	
	mov edx,7
	mov ecx,senha
	call readstr
	cmp eax,7
	jne _start
	xor esi,esi
	call valida
	cmp esi,6
	jne _start
	call poeinicio
	call readarq
	xor esi,esi
	call compara
	cmp esi,7
	jne _start
	call msg
	mov edx,7
	mov ecx,poearq
	call readstr
	mov esi,0
	call revalida
	cmp esi,6
	jne _start
	call gofinalarq
	call escrevearq
	call fechaarq
	
	ret
	

;Other Procedure
revalida:
		
	mov al,[poearq+esi] ;car. origem 
	cmp al,"A" ; A C E
	jb errototal
	cmp al,"Z"
	jg errototal	
	inc esi 
	mov al,[poearq+esi]
	cmp ax,"a" ; b d f
	jb errototal
	cmp ax,"z"
	jg errototal
	inc esi
	cmp esi,6
	jne revalida
	
	ret

;Other Procedure
valida:
		
	mov al,[senha+esi] ;car. origem 
	cmp al,"A" ; A C E
	jb _start
	cmp al,"Z"
	jg _start	
	inc esi 
	mov al,[senha+esi]
	cmp ax,"a" ; b d f
	jb _start
	cmp ax,"z"
	jg _start
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
	

;Other Procedure
fim:
	call fechaarq
	mov eax,1 ; serviço EXIT
	int 80h ;encerra (mesmo kernel para executar.. esse é o padrão)
	ret
	
;Other Procedure 
errorfile:

	mov edx,tam
	mov ecx,erroab
	mov ebx,1 
	mov eax,4
	int 80h
	jmp fim
	ret

acesso:
	
	mov edx, taminst
	mov ecx, inst
	call printstr
	mov edx,100
	mov ecx,auxsenha
	call readstr
	call poeinicio
	xor esi,esi
	call comparaaux

	ret
	
for:
	
	mov esi,0
	call deixala
	call comparaaux
	ret

comparaaux:

	call readarq
	cmp eax,0
	jbe sucess
	mov al,[auxsenha+esi]
	mov ah,[pegaarq+esi]
	cmp al,ah
	jne _start
	inc esi
	cmp esi,7
	jne comparaaux
	jmp for

	ret

compara:
	
	mov al,[senha+esi]
	mov ah,[pegaarq+esi]
	cmp al,ah
	jne _start
	inc esi
	cmp esi,7
	jne compara
	
	ret

sucess:

	mov edx,tamsucess
	mov ecx,mensucess
	call printstr
	mov edx,100
	mov ecx,auxerro
	call readstr
	mov edi,0
	cmp edi,0
	je _start

	ret

errototal:
	
	mov edx,tamerro
	mov ecx,erro
	call printstr
	mov edx,100
	mov ecx,auxerro
	call readstr
	mov edi,0
	cmp edi,0
	je _start

	ret

deixala:

	mov edx,1
	mov ecx,0
	mov ebx,[fd_in]
	mov eax,19
	int 80h

	ret

poeinicio:

	mov edx,0
	mov ecx,0
	mov ebx,[fd_in]
	mov eax,19
	int 80h

	ret

readarq:

	mov edx,7
	mov ecx,pegaarq
	mov ebx,[fd_in]
	mov eax,3
	int 80h
	
	ret

escrevearq:

	mov edx,7
	mov ecx,poearq
	mov ebx,[fd_in]
	mov eax,4
	int 80h
	
	ret

gofinalarq:
	
	mov edx,2
	mov ecx,0
	mov ebx,[fd_in]
	mov eax,19
	int 80h
	
	ret

msg:

	mov edx,tamdigita
	mov ecx,mendigita
	call printstr

	ret
