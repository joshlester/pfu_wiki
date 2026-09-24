
## GNU Shred
```bash
sudo shred -vfz /dev/sdX
```

Shred has many options:

n - the number of overwrites. The default is three.
u - overwrite and delete.
s - the number of bytes to shred.
v - show extended information.
f - force the change of permissions to allow writing if necessary.
z - add a final overwrite with zeros to hide shredding.
Use shred --help for more information