str_disk_failed:        db 'Disk read failed!', ENDL, 0
str_loading:            db 'Loading...', ENDL, 0
str_kernel_not_found:   db 'Kernel not found!', ENDL, 0
str_file_kernel_bin:    db 'KERNEL  BIN'
kernel_cluster:         dw 0

KERNEL_LOAD_SEGMENT     equ 0x2000
KERNEL_LOAD_OFFSET      equ 0