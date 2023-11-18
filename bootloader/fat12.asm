jmp short start
nop

disk_oem:                    db 'MSWIN4.1'
disk_bytes_per_sector:       dw 512
disk_sectors_per_cluster:    db 1
disk_reserved_sectors:       dw 1
disk_fat_count:              db 2
disk_dir_entries_count:      dw 0E0h
disk_total_sectors:          dw 2880
disk_media_descriptor_type:  db 0F0h
disk_sectors_per_fat:        dw 9
disk_sectors_per_track:      dw 18
disk_heads:                  dw 2
disk_hidden_sectors:         dd 0
disk_large_sector_count:     dd 0

disk_drive_number:           db 0
                             db 0
disk_signature:              db 29h
disk_volume_id:              db 12h, 34h, 56h, 78h
disk_volume_label:           db 'ZOS'
disk_system_id:              db 'FAT12   '