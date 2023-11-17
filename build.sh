nasm bootloader/bootloader.asm -f bin -o dist/bootloader.bin
cp dist/bootloader.bin dist/zync_os.img
truncate -s 1440k dist/zync_os.img