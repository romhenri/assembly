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
    buffer      db " bytes", 0                ; Texto " bytes"
    outputBuffer db 11 dup (?)                ; Buffer para o número do tamanho do arquivo
    hConsole        dd ?                          ; Handle da console
    bytesWritten dd ?                         ; Número de bytes escritos no console

.code
start:
    ; Obter handle da saída padrão
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hConsole, eax

    ; Abrir o arquivo
    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle, eax

    cmp fileHandle, INVALID_HANDLE_VALUE
    je erro_abrir

    ; Obter o tamanho do arquivo
    invoke GetFileSize, fileHandle, NULL
    mov fileSize, eax

    cmp eax, INVALID_FILE_SIZE
    je erro_obter_tamanho

    ; Converter o valor do tamanho do arquivo para string
    invoke dwtoa, fileSize, addr outputBuffer

    ; Escrever o tamanho do arquivo no console
    invoke WriteConsole, hConsole, addr outputBuffer, , addr bytesWritten, NULL

    ; Escrever " bytes" no console
    invoke WriteConsole, hConsole, addr buffer, 6, addr bytesWritten, NULL

    ; Fechar o arquivo e sair
    invoke CloseHandle, fileHandle
    invoke ExitProcess, 0

erro_abrir:
    invoke ExitProcess, 1

erro_obter_tamanho:
    invoke ExitProcess, 2

end start
