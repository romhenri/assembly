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
    helloWorld db 'Hello, World!', 0       ; Mensagem "Hello, World!" com terminador nulo
    hConsole    dd ?                       ; Handle da sa�da padr�o
    bytesWritten dd ?                      ; Vari�vel para armazenar o n�mero de bytes escritos

.code
start:
    ; Obter o handle da sa�da padr�o (console)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hConsole, eax                      ; Armazenar o handle do console

    ; Escrever a mensagem "Hello, World!" no console
    invoke WriteConsole, hConsole, addr helloWorld, 13, addr bytesWritten, NULL

    ; Finalizar o processo
    invoke ExitProcess, 0

end start
