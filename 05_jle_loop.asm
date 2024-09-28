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

.code
start:
    mov eax, 0

increment_loop:
    push eax
    push ecx
    push edx

    printf("%d\n", eax)
    
    pop edx
    pop ecx
    pop eax
    
    add eax, 1
    cmp eax, 12
    jle increment_loop

    invoke ExitProcess, 0

end start
