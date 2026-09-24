
# VirtualBox

## Error/Solution
 - Error: Can't operate in VMX Mode
 - Solution:
```sh
sudo modprobe -r kvm_intel
```
<br>

## Guest Additions
Check version
```
/usr/sbin/VBoxService --version
```
<br>

## Share folder
When adding a share folder, within the virtual machine OS add
the user(s) who should have access to the share to the vboxsf group
```
sudo usermod -aG vboxsf userX
```
