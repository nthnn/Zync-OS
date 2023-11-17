%include "bootloader/constants.asm"

org ORIGIN_ADDR
bits BTLDR_BITS

start:
    mov ax, 0
    mov ds, ax
    mov es, ax
    
    mov ss, ax
    mov sp, 0x7C00

    call clearScreen

    mov si, str_greet
    call printString

    call shell
    hlt

.halt:
    jmp .halt

clearScreen:
    mov ax, CLEAR_SCREEN
    mov bh, 0x07
    mov cx, 0
    mov dx, 0x184F
    int VIDEO_INT

    mov ax, CARET_POSITION
    xor bh, bh
    xor dh, dh
    xor dl, dl
    int VIDEO_INT

    ret

printString:
    push si
    push ax
    push bx

.loop:
    lodsb
    or al, al
    jz .done

    mov ah, 0x0E
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si   
    ret

getInput:
    mov di, si
    mov cx, 0

.readKey:
    mov ah, 0
    int 0x16

    cmp al, 0x0D
    je .inputDone

    mov ah, 0x0E
    mov bh, 0
    int 0x10

    mov [di], al
    inc di
    inc cx

    jmp .readKey

.inputDone:
    mov byte [di], 0
    ret

shell:
    mov si, str_shell
    call printString

    mov si, input_buffer
    call getInput
    mov di, si

    mov si, str_nline
    call printString

    mov si, di
    call printString

    mov si, str_nline
    call printString

    mov si, str_nline
    call printString

    jmp shell

str_greet:      db 'Zync OS (Shell) v0.0.1', ENDL, ENDL, 0
str_shell:      db '%> ', 0
str_nline:      db '', ENDL, 0

input_buffer: times 100 db 0

times 510-($-$$) db 0
dw 0AA55h
