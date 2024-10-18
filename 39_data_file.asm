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

.data
fileName    db "sw.wav", 0                ; Nome do arquivo
fileHandle  dd ?                          ; Handle do arquivo
fileSize    dd ?                          ; Tamanho do arquivo
bytesRead   dd ?                          ; Quantidade de bytes lidos
headerSize  dd 44                         ; Tamanho do cabeçalho WAV (44 bytes)
buffer      db 44 dup(?)                  ; Buffer para armazenar o cabeçalho WAV
dataBuffer  db 4096 dup(?)                ; Buffer para armazenar os dados binários (4 KB para exibir por partes)

.code
start:
    ; Abre o arquivo WAV
    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle, eax

    ; Verifica se o arquivo foi aberto corretamente
    cmp fileHandle, INVALID_HANDLE_VALUE
    je erro_abrir

    ; Obtém o tamanho total do arquivo
    invoke GetFileSize, fileHandle, NULL
    mov fileSize, eax

    ; Lê os primeiros 44 bytes do cabeçalho WAV
    invoke ReadFile, fileHandle, addr buffer, 44, addr bytesRead, NULL

    ; Exibe os primeiros campos do cabeçalho WAV
    printf("Chunk ID: %c%c%c%c\n", byte ptr [buffer], byte ptr [buffer+1], byte ptr [buffer+2], byte ptr [buffer+3])
    mov eax, dword ptr [buffer + 4]
    printf("Chunk Size: %u bytes\n", eax)
    printf("Format: %c%c%c%c\n", byte ptr [buffer+8], byte ptr [buffer+9], byte ptr [buffer+10], byte ptr [buffer+11])
    movzx eax, word ptr [buffer + 22]
    printf("Num Channels: %u\n", eax)
    mov eax, dword ptr [buffer + 24]
    printf("Sample Rate: %u\n", eax)
    movzx eax, word ptr [buffer + 34]
    printf("Bits per Sample: %u\n", eax)

    ; Agora exibe os dados binários
    printf("\nExibindo dados binários a partir do offset 44:\n")

    ; Loop para ler e exibir os dados binários
    .repeat:
        ; Lê até 4096 bytes por vez (ou menos se for o final do arquivo)
        invoke ReadFile, fileHandle, addr dataBuffer, 4096, addr bytesRead, NULL
        test eax, eax
        je fim_dados                ; Sai do loop se nenhum dado for lido (fim do arquivo)

        ; Exibe os bytes lidos
        mov ecx, bytesRead
        mov esi, offset dataBuffer
    mostra_byte:
        movzx eax, byte ptr [esi]
        printf("%02X ", eax)        ; Exibe o byte em formato hexadecimal
        inc esi
        loop mostra_byte
        printf("\n")                ; Quebra de linha após cada bloco de 4096 bytes

        ; Verifica se leu todos os bytes do arquivo
        cmp fileSize, headerSize
        jle fim_dados
        sub fileSize, 4096
    .until fileSize <= 44           ; Repete até que todos os bytes após o cabeçalho sejam lidos

fim_dados:
    ; Fecha o arquivo
    invoke CloseHandle, fileHandle
    invoke ExitProcess, 0

erro_abrir:
    invoke ExitProcess, 1

end start
