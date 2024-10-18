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
fileName    db "sw.wav", 0                ; Nome do arquivo
fileHandle  dd ?                          ; Handle do arquivo
fileSize    dd ?                          ; Tamanho do arquivo

.code
start:
    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle, eax

    cmp fileHandle, INVALID_HANDLE_VALUE
    je erro_abrir

    invoke GetFileSize, fileHandle, NULL
    mov fileSize, eax

    cmp eax, INVALID_FILE_SIZE
    je erro_obter_tamanho

    printf("%u bytes", fileSize)

    invoke CloseHandle, fileHandle
    invoke ExitProcess, 0

erro_abrir:
    invoke ExitProcess, 1

erro_obter_tamanho:
    invoke ExitProcess, 2

end start
