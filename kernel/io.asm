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

.printLoop:
    lodsb
    or al, al
    jz .printDone

    mov ah, 0x0E
    mov bh, 0
    int 0x10

    jmp .printLoop

.printDone:
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
