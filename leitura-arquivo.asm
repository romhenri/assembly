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
fileName            db "sw.wav", 0                 ; Nome do arquivo
fileBuffer          db 10 dup(?)                   ; Buffer para armazenar os bytes lidos
readCount           dd ?                           ; Número de bytes realmente lidos
fileHandle          dd ?                           ; Handle para o arquivo
sizeMessage         db "Tamanho do arquivo: %u bytes", 0   ; Mensagem com formato para .printf

.code
start:
    ; Abrir o arquivo "sw.wav" para leitura
    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle, eax                            ; Guardar o handle do arquivo

    ; Verificar se o arquivo foi aberto com sucesso (INVALID_HANDLE_VALUE = -1)
    cmp fileHandle, INVALID_HANDLE_VALUE
    je erro_ao_abrir

    ; Ler 10 bytes do arquivo para o buffer
    invoke ReadFile, fileHandle, addr fileBuffer, 10, addr readCount, NULL

    ; Verificar se a leitura foi bem-sucedida
    cmp eax, 0                                     ; Se eax for 0, ocorreu erro
    je erro_na_leitura

    ; Obter o tamanho do arquivo
    invoke GetFileSize, fileHandle, NULL
    mov ebx, eax                                   ; Guardar o tamanho do arquivo em ebx

    ; Usar .printf para exibir o tamanho do arquivo
    printf("%u bits\n", ebx)                       ; Imprimir mensagem formatada com o tamanho do arquivo

    ; Fechar o arquivo
    invoke CloseHandle, fileHandle

    ; Sair do programa
    invoke ExitProcess, 0

erro_ao_abrir:
    ; Tratar erro ao abrir o arquivo (pode mostrar uma mensagem, etc.)
    invoke ExitProcess, 1

erro_na_leitura:
    ; Tratar erro ao ler o arquivo
    invoke ExitProcess, 2

end start

