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
    push 10
    push 2

    call sum_two_numbers

    printf("%d", eax)

    invoke ExitProcess, 0

sum_two_numbers proc
    push ebp
    
    mov ebp, esp
    mov eax, [ebp+8]
    add eax, [ebp+12]
    
    pop ebp
    
    ret
sum_two_numbers endp

end start
