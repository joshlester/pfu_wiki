
# Fedora

## Upgrade
```
sudo dnf system-upgrade download --releasever=38
sudo dnf system-upgrade reboot

sudo dnf clean packages
```

## Issues
### Bluetooth
#### Issue
Unable to turn bluetooth on

#### Solution
Remove and re-add btusb and restart service.
```
sudo rmmod btusb && sudo modprobe btusb && sudo systemctl restart bluetooth.service
```

## Repo info
Repo information is located at
```
/etc/yum.repos.d
```

## Issues

### Issue
Boot to blank screen.

### Reason
Was a bad Josh's iPhone.nmconnection file.
>/etc/NetworkManager/system-connections

Network was pointing to local IP 127.0.0.x as it's Domain Name Server.

### Resolution
https://unix.stackexchange.com/questions/90035/how-to-set-dns-resolver-in-fedora-using-network-manager
Delete bad connection file.