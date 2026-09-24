
# Backup

### Backup pictures to OneDrive (encrypted)
```
rclone sync -P /media/josh/STUFF/docs one_drive_encrypt:Documents

rclone copy -P --ignore-existing /mnt/black_box/media/personal onedrive_crypt:pictures

rclone sync -P /media/josh/STUFF/archive one_drive_encrypt:archive
```

## Backup home folder (~)
Backup home folder to rclone mounted OneDrive encrypt folder using rysnc
```
rsync -Pav --del --include-from=/home/josh/.config/rsync/rsync_home_backup_include.txt --exclude-from=/home/josh/.config/rsync/rsync_home_backup_exclude.txt /home/josh/ /home/josh/one_drive_encrypt/backups/daily/$(date +%Y-%m-%d)/
```