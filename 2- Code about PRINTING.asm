;PUC-ECEC-CMP1057-ARQ1-
;12/02/19
;Wellington Junio De Melo Fernandes
;
;Segundo Programa print.asm

segment .data
;dados inicializados

mens db "Adeus mundo cruel",10,10,"é mentira hahaha",10,10
tamm equ $-mens ; tamm=constante ao ponto que estou no caso 18 - a quantidade de palavras do vetor anterior
segment .text

global _start

_start:
print:

	mov edx,tamm ;quantidade de caracteres, no caso ele imprime o tamanho armazenado em tamm
	mov ecx,mens ;ponteiro da string
	mov ebx,0 ;FD monitor
	mov eax,4 ;Serviço PRINT
	int 0x80 ;Kernel para executar serviço
	
sai:

	mov eax,1 ; serviço EXIT
	int 80h ;encerra (mesmo kernel para executar.. esse é o padrão)
	
	
