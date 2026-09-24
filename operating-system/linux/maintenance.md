
## Wipe disk
https://itjustmadesimple.wordpress.com/2021/09/19/wiping-disk-drives-in-linux/
```
dd if=/dev/zero of=/dev/sdb bs=1M status=progress
```