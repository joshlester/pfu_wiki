
# Local Mounts

Mount OneDrive folder
```
rclone mount --daemon --vfs-cache-mode writes onedrive:/ /home/josh/onedrive
```

Mount OneDrive crypt folder
```
rclone mount --daemon --vfs-cache-mode writes onedrive_crypt:/ /home/josh/onedrive_crypt

```

## Bytenaut mounts
Options
 - ```--vfs-cache-mode writes```: Ensures that writes are cached locally before being uploaded to the remote.
 - ```--buffer-size 64M```
```sh
rclone mount --daemon bytenaut_cloudflare_r2:cdn /home/josh/bytenaut_r2 --vfs-cache-mode writes --buffer-size 64M
```