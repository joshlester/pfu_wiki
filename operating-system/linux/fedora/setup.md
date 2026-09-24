
# Fedora Setup

* Dconf Editor
#gnome
(Software app)

* Gnome Extension Manager
#gnome
(Software app - Extension Manager)

## Plugins
#gnome #nautilus
```
sudo dnf install nautilus-image-converter
```

**1. Update dnf configs**
[[software/dnf|dnf]]

**2. Install fusion repositories**

Enabling the RPM Fusion repositories using command-line utilities

```
sudo dnf install \
      https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
```

Optionally, enable the Nonfree repository:
```
sudo dnf install \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

**3. Install Tilix**
[[software/tilix|tilix]]

**4. Install nvm (Node Version Manager)**
[[software/npm|npm]]

**5. Install JetBrains Mono (available via Software app)**

**6. Install Shotwell (available via Software app)**

**7. Install Gitkraken**

**8. Install rsync & rclone**
```
curl https://rclone.org/install.sh | sudo bash
```

**9. Install VirtualBox**

**10. Install flatpak flathub repository**

## Extensions
**11.0 Gnome shell integration for firefox**
**11.1 Clipboard indicator**
**11.2 Dash to panel**
**11.2 OpenWeather**
```
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Themes
**12. Colloid-dark-nord** applicaitons theme.
**13. Papirus-Dark icon set.**
**14. Nordzy-Cursors**

**15. Installing plugins for playing movies and music**
https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/

**16. Plex media player (not working)**

**17. VLC**

**18. Filezilla**

**19. Install Rust and Cargo**
```
sudo dnf install rust cargo
```

**20. Install Deno**
```
cargo install deno
```

**21. Postman**
Software app

**22. DBeaver**
Software app

**23. Gulp**
https://gulpjs.com/docs/en/getting-started/quick-start/
Install gulp-cli globally
```
npm install --global gulp-cli
```
Install gulp in project dev dependencies
```
npm install --save-dev gulp
```
**24. qBittorrent** (via software)

**25. p7zip**
terminal_util
```
sudo dnf install p7zip p7zip-plugins
```

**26. Install starship**
https://starship.rs/

**27. Install Nerd font**
As recommended by Starship (shows ligatures).
A <a href="https://www.nerdfonts.com/" target="_blank" rel="noopener noreferrer">Nerd Font<span></span></a> installed and enabled in your terminal (for example, try the <a href="https://www.nerdfonts.com/font-downloads" target="_blank" rel="noopener noreferrer">Fira Code Nerd Font</span></a>).

**28. Install ZSH autosuggestions**
https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md

**29. Install ZSH-Z**
https://github.com/agkozak/zsh-z

**30. Install Developer Tools**
Required to build eltirus enable
*May only require installing C Development Tools and Libraries*
xml2json is the lib which requires which requires this dependency.
Would love to use an alternative.
```
sudo dnf group install "Development Tools"
sudo dnf group install "C Development Tools and Libraries"
```

**31. KBCT - Keyboard Customization Tool for Linux**
https://github.com/samvel1024/kbct
https://fooboo.bar/en/server-admin/systemd

**32. Signal Desktop**
Install via software app

**33. Espanso**
https://espanso.org/docs/install/linux/#wayland-compile