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
    push 26]
    push 12

    call sub_two_numbers

    printf("%d", eax)

    invoke ExitProcess, 0

sub_two_numbers proc
    push ebp
    
    mov ebp, esp
    mov eax, [ebp+12]
    sub eax, [ebp+8]
    
    pop ebp
    
    ret
sub_two_numbers endp

end start
