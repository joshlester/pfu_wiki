
### Rsync

#### Send file to vultr server
```
rsync -Pr /home/josh/project/josh_wiki/ root@149.28.183.7:/srv/www/josh_wiki/
```

#### Backup to portable drive
```
rsync -Pav --exclude-from=rsync_exclude2.txt /home/josh/ /media/josh/Storage1/backups/2022-03-03/
```

### Rclone
__Sync pictures to OneDrive__
```
rclone sync -P /media/josh/Storage/pictures one_drive:pictures
```

## Visual Studio Code [dev]
### Plugins
* Apache Conf
* Better Comments
* Bracket Pair Colorizer
* Vim
* Vim - Code Ace Jumper
* Dracula Official (theme)
* Debugger for Chrome
* Debugger for Firefox
* Docker
* ESLint
* GitLens
* Image preview
* npm
* npm intellisense
* Tailwind CSS IntelliSense
* Template String Converter
* XML Tools
* YAML
* Error Lens
* Paste JSON as Code
* Visual Studio IntelliCode
* Nunjunks (https://marketplace.visualstudio.com/items?itemName=ronnidc.nunjucks)

## DB Schema [dev]
## Postman or Insomnia [dev]
## Signal
## JetBrains (PHPStorm/IntelliJ)[dev]
* Material Theme UI
* Atom Material Icons

## Peek
Peek is a handy utility tool with which you can record your screen and quickly turn the videos into Gif animations. It is beautifully designed, lightweight, and straightforward.

```
$ sudo add-apt-repository ppa:peek-developers/stable
$ sudo apt update
$ sudo apt install peek

```

## XnConvert
Image manipulation software

## zsh
Terminal emulator language.
Config file (location ~) [[os_install_linux/.zshrc|.zshrc]]

## Joplin
https://joplinapp.org/
Open source note taking app.

## Bitwarden
password manager.

## John the ripper
Crack PDF passwords
https://github.com/openwall/john
To install follow instructions at:
https://github.com/openwall/john/blob/bleeding-jumbo/doc/INSTALL-UBUNTU
Previously installed it in a docker using the following commands:
```
=== Preconditions and Required stuff

    sudo apt-get -y install git build-essential libssl-dev zlib1g-dev

==== Recommended (extra formats and performance)

    sudo apt-get -y install yasm pkg-config libgmp-dev libpcap-dev libbz2-dev
    
==== Clone the Git repo

    git clone https://github.com/openwall/john -b bleeding-jumbo john

==== Build

    cd john
    ./configure && make -s clean && make -sj4    
```
Run following commands to crack:
```
# Retrieve hash from zip file and output to file.
./zip2john /tmp/welcomeLetter_20210623_201133.pdf.zip > /tmp/hash.txt

# Crack password by running john and passing in hash file.
./john/run/john hash.txt 
```
<br>

## czkawka
https://github.com/qarmin/czkawka/releases/
File utility which can be used to find duplicates and empty files.

Install using:
https://github.com/qarmin/czkawka/releases/download/3.1.0/linux_czkawka_gui.AppImage
<br>

## Convert HEIF Images to JPG or PNG (linux)
https://linuxnightly.com/convert-heif-images-to-jpg-or-png-on-linux/
```
sudo apt install libheif-examples
```
```
for f in *.HEIC; do heif-convert -q 100 $f $f.jpg; done
```

## OBS Studio
Screen recording software.
https://obsproject.com/

## rclone
Rclone is a command line program to manage files on cloud storage. It is a feature rich alternative to cloud vendors' web storage interfaces. Over 40 cloud storage products support rclone including S3 object stores, business & consumer file storage services, as well as standard transfer protocols.
https://rclone.org/

## Tabula
https://github.com/tabulapdf/tabula
If you’ve ever tried to do anything with data provided to you in PDFs, you know how painful this is — you can’t easily copy-and-paste rows of data out of PDF files. Tabula allows you to extract that data in CSV format, through a simple web interface.

Caveat: Tabula only works on text-based PDFs, not scanned documents. If you can click-and-drag to select text in your table in a PDF viewer (even if the output is disorganized trash), then your PDF is text-based and Tabula should work.
