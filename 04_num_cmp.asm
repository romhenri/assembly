.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib

include \masm32\macros\macros.asm

.data
    msg db "A soma dos 100 primeiros numeros inteiros positivos eh: ", 0
    resultStr db 11 dup(0)   ; Para armazenar o número convertido em string

.code
start:
    xor eax, eax
    xor ecx, ecx

soma_loop:
    inc ecx
    add eax, ecx
    cmp ecx, 100
    jle soma_loop

    invoke dwtoa, eax, addr resultStr

    printf("%d", eax)

    invoke ExitProcess, 0

end start