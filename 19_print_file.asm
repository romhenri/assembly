.686                           ; Arquitetura .686 com suporte a instruções de 32 bits estendidas
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib

.data
    inputFileName    db 50 dup(?)         ; Buffer para o nome do arquivo de entrada
    outputFileName   db 50 dup(?)         ; Buffer para o nome do arquivo de saída
    volumeReduction  WORD ?               ; Constante de redução de volume
    fileHeader       db 44 dup(?)         ; Buffer para armazenar o cabeçalho do arquivo WAV
    inputBuffer      db 16 dup(?)         ; Buffer para leitura do arquivo de entrada
    outputBuffer     db 16 dup(?)         ; Buffer para escrita no arquivo de saída
    bytesRead        DWORD ?              ; Número de bytes lidos
    bytesWritten     DWORD ?              ; Número de bytes escritos
    hInputFile       DWORD ?              ; Handle para o arquivo de entrada
    hOutputFile      DWORD ?              ; Handle para o arquivo de saída
    userResponse     db "Deseja processar outro arquivo? (S/N): ", 0
    yesResponse      db "S", 0

    msgInputFileName db "Digite o nome do arquivo de entrada: ", 0
    msgOutputFileName db "Digite o nome do arquivo de saída: ", 0
    msgVolumeReduction db "Digite a constante de redução de volume (1 a 10): ", 0

.code
start:
    ; Exibir mensagem para entrada do nome do arquivo de entrada
    invoke StdOut, addr msgInputFileName
    invoke StdIn, addr inputFileName, 50  ; Corrigido para dois argumentos

    ; Exibir mensagem para entrada do nome do arquivo de saída
    invoke StdOut, addr msgOutputFileName
    invoke StdIn, addr outputFileName, 50  ; Corrigido para dois argumentos

    ; Exibir mensagem para entrada da constante de redução de volume
    invoke StdOut, addr msgVolumeReduction
    invoke StdIn, addr volumeReduction, 2  ; Lê apenas 2 bytes (tamanho de WORD)

    ; Abrir o arquivo de entrada
    invoke CreateFile, addr inputFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov hInputFile, eax

    ; Abrir/criar o arquivo de saída
    invoke CreateFile, addr outputFileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov hOutputFile, eax

    ; Ler e copiar o cabeçalho do arquivo WAV
    invoke ReadFile, hInputFile, addr fileHeader, 44, addr bytesRead, NULL
    invoke WriteFile, hOutputFile, addr fileHeader, 44, addr bytesWritten, NULL

process_loop:
    ; Ler 16 bytes do arquivo de entrada
    invoke ReadFile, hInputFile, addr inputBuffer, 16, addr bytesRead, NULL
    test eax, eax
    jz doneProcessing    ; Se nenhum byte foi lido, termina o processamento

    ; Chamar a função de redução de volume
    invoke ReduceVolume, addr inputBuffer, addr outputBuffer, volumeReduction

    ; Escrever o buffer processado no arquivo de saída
    invoke WriteFile, hOutputFile, addr outputBuffer, 16, addr bytesWritten, NULL

    jmp process_loop

doneProcessing:
    ; Fechar os arquivos
    invoke CloseHandle, hInputFile
    invoke CloseHandle, hOutputFile

    ; Perguntar ao usuário se deseja processar outro arquivo
    invoke StdOut, addr userResponse
    invoke StdIn, addr inputFileName, 50  ; Reaproveitando o buffer inputFileName
    invoke lstrcmpi, addr inputFileName, addr yesResponse
    jz start   ; Se o usuário responder "S", recomeça o processo

    ; Fim do programa
    invoke ExitProcess, 0

; Função para reduzir o volume de um buffer de áudio
; Parâmetros:
;   [esp+4] = endereço do buffer de entrada
;   [esp+8] = endereço do buffer de saída
;   [esp+12] = constante de redução de volume
ReduceVolume proc
    push ebp
    mov ebp, esp
    mov esi, [ebp+8]    ; Buffer de entrada
    mov edi, [ebp+12]   ; Buffer de saída
    mov cx, [ebp+16]    ; Constante de redução de volume

    ; Loop para processar 8 amostras de 2 bytes (16 bytes no total)
    mov ecx, 8
volume_loop:
    ; Carregar 2 bytes (1 amostra de áudio) no registrador AX
    movsx eax, WORD PTR [esi]
    
    ; Preparar divisão assinada por cx
    cwd                     ; Sinalizar o número para o registrador DX
    idiv cx                 ; Dividir por cx (constante de redução)

    ; Armazenar o resultado (reduzido) no buffer de saída
    mov [edi], ax

    ; Avançar para a próxima amostra
    add esi, 2
    add edi, 2
    loop volume_loop

    pop ebp
    ret
ReduceVolume endp

end start
