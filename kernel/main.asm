%include "kernel/defs.asm"

org  ORIGIN_ADDR
bits BTLDR_BITS

start:
    call clearScreen

    mov si, str_greet
    call printString

    call shell
    hlt

.halt:
    jmp .halt

%include "kernel/io.asm"
%include "kernel/shell.asm"
%include "kernel/constants.asm"

input_buffer: times 100 db 0

times 510-($-$$) db 0
dw 0AA55h
