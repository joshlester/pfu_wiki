
# Systemd

## Links
https://www.computernetworkingnotes.com/linux-tutorials/systemd-target-units-explained.html
https://superuser.com/questions/1037466/how-to-start-a-systemd-service-after-user-login-and-stop-it-before-user-logout/1269158
https://www.devdungeon.com/content/creating-systemd-service-files
<br>
<hr>

https://documentation.suse.com/smart/linux/single-html/reference-systemctl-enable-disable-services/index.html
```
# Control whether service loads on boot
sudo systemctl enable my_service
sudo systemctl disable my_service

# Manual start and stop
sudo systemctl start my_service
sudo systemctl stop my_service

# Restarting/reloading
sudo systemctl daemon-reload # Run if .service file has changed
systemctl --user daemon-reload  # For user services
sudo systemctl restart my_restart

# Or if working with a user service add --user flag
systemctl --user restart my_user_service
```

## Setup Keyboard Customisation Tool for Linux (KBCT)

- Add entry into `/etc/sudoers` file using `sudo visudo` command to enable kbct systemd user service to execute command with sudo without entering password.

https://linuxhandbook.com/sudo-without-password/
```
# Allow kbct to be started by systemd user service
josh ALL=(ALL) NOPASSWD:/home/josh/apps/kbct-x86_64.AppImage remap --config /home/josh/.config/kbct.yaml

```

- Created kbct (see backups) systemd user service. Needed to include 10secs delay (using `ExecStartPre=/usr/bin/sleep 10`) to get service to start after user login.
```
[Unit]
Description=Keyboard Customisation Tool

[Service]
Type=oneshot
# Type=simple
# Another Type: forking
RemainAfterExit=true
StandardOutput=journal  
# Omit user/group if creating user service file
# User=josh 
# Group=josh
# WorkingDirectory=/home/josh
ExecStartPre=/usr/bin/sleep 10
ExecStart=/usr/bin/sudo /home/josh/apps/kbct-x86_64.AppImage remap --config 
# Restart=on-failure
# Other restart options: always, on-abort, etc

# The install section is needed to use
# `systemctl enable` to start on boot
# For a user service that you want to enable
# and start automatically, use `default.target`
# For system level services, use `multi-user.target`

[Install]
WantedBy=default.target
```