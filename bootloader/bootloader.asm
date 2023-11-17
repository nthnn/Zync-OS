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

    mov si, msg_hello
    call printString

    hlt

.halt:
    jmp .halt

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

msg_hello: db 'Zync OS (Bootloader)', 0
input_buffer: times 100 db 0

times 510-($-$$) db 0
dw 0AA55h
