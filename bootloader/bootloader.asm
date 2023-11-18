%include "bootloader/defs.asm"

org ORIGIN_ADDR
bits BTLDR_BITS

%include "bootloader/fat12.asm"

start:
    mov ax, 0
    mov ds, ax
    mov es, ax
    
    mov ss, ax
    mov sp, 0x7C00

    push es
    push word .after
    retf

.after:
    mov [disk_drive_number], dl
    mov si, str_loading
    call printString

    push es
    mov ah, 08h
    int 13h
    jc floppyDiskError
    pop es

    and cl, 0x3F
    xor ch, ch
    mov [disk_sectors_per_track], cx

    inc dh
    mov [disk_heads], dh

    mov ax, [disk_sectors_per_fat]
    mov bl, [disk_fat_count]
    xor bh, bh
    mul bx
    add ax, [disk_reserved_sectors]
    push ax

    mov ax, [disk_dir_entries_count]
    shl ax, 5
    xor dx, dx
    div word [disk_bytes_per_sector]

    test dx, dx
    jz .rootDirAfter
    inc ax

.rootDirAfter:
    mov cl, al
    pop ax
    mov dl, [disk_drive_number]
    mov bx, buffer
    call diskRead

    xor bx, bx
    mov di, buffer

.searchKernel:
    mov si, str_file_kernel_bin
    mov cx, 11
    push di
    repe cmpsb

    pop di
    je .foundKernel

    add di, 32
    inc bx

    cmp bx, [disk_dir_entries_count]
    jl .searchKernel

    jmp noKernelFound

.foundKernel:
    mov ax, [di + 26]
    mov [kernel_cluster], ax

    mov ax, [disk_reserved_sectors]
    mov bx, buffer
    mov cl, [disk_sectors_per_fat]
    mov dl, [disk_drive_number]
    call diskRead

    mov bx, KERNEL_LOAD_SEGMENT
    mov es, bx
    mov bx, KERNEL_LOAD_OFFSET

.loadKernel:
    mov ax, [kernel_cluster]
    add ax, 31

    mov cl, 1
    mov dl, [disk_drive_number]
    call diskRead

    add bx, [disk_bytes_per_sector]

    mov ax, [kernel_cluster]
    mov cx, 3
    mul cx
    mov cx, 2
    div cx

    mov si, buffer
    add si, ax
    mov ax, [ds:si]

    or dx, dx
    jz .even

.odd:
    shr ax, 4
    jmp .nextCluster

.even:
    and ax, 0x0FFF

.nextCluster:
    cmp ax, 0x0FF8
    jae .finish

    mov [kernel_cluster], ax
    jmp .loadKernel

.finish:
    mov dl, [disk_drive_number]

    mov ax, KERNEL_LOAD_SEGMENT
    mov ds, ax
    mov es, ax

    jmp KERNEL_LOAD_SEGMENT:KERNEL_LOAD_OFFSET
    jmp waitKeyReboot

    cli
    hlt

%include "bootloader/print_string.asm"
%include "bootloader/disk_util.asm"
%include "bootloader/constants.asm"

times 510-($-$$) db 0
dw 0AA55h

buffer: