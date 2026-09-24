
1. Add template file
```sh
chezmoi add --template ~/.config/rclone/rclone.conf
```

2. Navigate to chezmoi
```sh
chezmoi cd
```

3. Edit file by replacing secrets with pass template fields
```e.g. password = {{ pass "josh/one_drive_encrypt_password" }}```
```sh
zed dot_config/rclone/rclone.conf.tmpl
```

- FYI Secrets are stored in pass using command
```sh
pass insert josh/one_drive_encrypt_password
```

4. Apply chezmoi changes to target directory
```sh
chezmoi apply
```




