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
bytesRead   dd ?                          ; Quantidade de bytes lidos
buffer      db 44 dup(?)                  ; Buffer para armazenar o cabeçalho WAV

.code
start:
    ; Abre o arquivo WAV
    ;fileName db "sw.wav", 0
    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle, eax

    ; Verifica se o arquivo foi aberto corretamente
    cmp fileHandle, INVALID_HANDLE_VALUE
    je erro_abrir

    ; Lê os primeiros 44 bytes do cabeçalho WAV
    invoke ReadFile, fileHandle, addr buffer, 44, addr bytesRead, NULL

    ; Exibe os primeiros campos do cabeçalho WAV

    ; Exibe o Chunk ID (os primeiros 4 bytes)
    printf("Chunk ID: %c%c%c%c\n", byte ptr [buffer], byte ptr [buffer+1], byte ptr [buffer+2], byte ptr [buffer+3])

    ; Exibe o Chunk Size (os próximos 4 bytes)
    mov eax, dword ptr [buffer + 4]
    printf("Chunk Size: %u bytes\n", eax)

    ; Exibe o Format (os próximos 4 bytes)
    printf("Format: %c%c%c%c\n", byte ptr [buffer+8], byte ptr [buffer+9], byte ptr [buffer+10], byte ptr [buffer+11])

    ; Exibe o número de canais (2 bytes no offset 22)
    movzx eax, word ptr [buffer + 22]
    printf("Num Channels: %u\n", eax)

    ; Exibe a taxa de amostragem (4 bytes no offset 24)
    mov eax, dword ptr [buffer + 24]
    printf("Sample Rate: %u\n", eax)

    ; Exibe o Bits per Sample (2 bytes no offset 34)
    movzx eax, word ptr [buffer + 34]
    printf("Bits per Sample: %u\n", eax)

    ; Fecha o arquivo
    invoke CloseHandle, fileHandle
    invoke ExitProcess, 0

erro_abrir:
    invoke ExitProcess, 1

end start
