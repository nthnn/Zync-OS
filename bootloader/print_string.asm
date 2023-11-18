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