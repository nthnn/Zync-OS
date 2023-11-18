waitKeyReboot:
    mov ah, 0
    int 16h
    jmp 0FFFFh:0

.halt:
    cli
    hlt

convLba2Chs:
    push ax
    push dx

    xor dx, dx
    div word [disk_sectors_per_track]

    inc dx
    mov cx, dx

    xor dx, dx
    div word [disk_heads]

    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax
    ret

diskRead:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx
    call convLba2Chs
    pop ax

    mov ah, 02h
    mov di, 3

.retry:
    pusha
    stc

    int 13h
    jnc .done

    popa
    call diskReset

    dec di
    test di, di
    jnz .retry

.fail:
    jmp floppyDiskError

.done:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

diskReset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc floppyDiskError
    popa
    ret

floppyDiskError:
    mov si, str_disk_failed
    call printString
    jmp waitKeyReboot

noKernelFound:
    mov si, str_kernel_not_found
    call printString
    jmp waitKeyReboot
