
# Server

## Commands
Giving a user sudo privileges
On Fedora, it is the wheel group the user has to be added to, as this group has full admin privileges. Add a user to the group using the following command:
```
sudo usermod -aG wheel username
```


## SSH
https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04
https://www.ssh.com/academy/ssh/keygen


 List the size of the top 10 (head defaults to 10) child directories from largest to smallest
 ```
du -h --max-depth=1 | sort -hr | head
```

<br />

## Mount NAS

Mount N7710-G NAS (terminal)
```
sudo mount -t cifs -o credentials=~/.credentials,uid=1000,gid=1001,file_mode=0775,dir_mode=0775 //192.168.20.100/media /mnt/n7710-g/media
```

Mount N7710-G NAS (/etc/fstab)
```
//192.168.20.100/media /mnt/n7710-g/media cifs credentials=/root/.n7710-g,uid=1000,gid=1001,file_mode=0775,dir_mode=0775 0 0
```

### Links
Mount permissions
https://unix.stackexchange.com/questions/465433/mount-cifs-with-group-permissions

Issue - "user" CIFS mounts not supported.
https://superuser.com/questions/1444883/user-cifs-mounts-not-supported-fedora-30

Mount walkthrough
https://www.youtube.com/watch?v=RIS482WvbM4&ab_channel=SpaceRex
