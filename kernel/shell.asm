shell:
    mov si, str_shell
    call printString

    mov si, input_buffer
    call getInput

    mov di, si
    mov di, str_clear_cmd

    repe cmpsb
    cmp byte [di], 0
    jne .invalidCommand

    mov si, str_nline
    call printString

    call clearScreen
    jmp .shellEnd

.invalidCommand:
    mov si, str_nline
    call printString

    mov si, str_invalid_cmd
    call printString

.shellEnd:
    jmp shell
