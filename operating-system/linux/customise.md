
* <a href="#map-caps-to-esc">Map Caps Lock to Escape</a>
* <a href="#map-caps-to-caps">Map Caps Lock to Caps Lock</a>
* <a href="#change-open-in-terminal">Change Open in Terminal</a>
* <a href="#setup-wacom-tablet">Setup Wacom Tablet</a>

# Customise

<a id="remap-keys"></a>

<a href="https://github.com/microsoft/vscode/issues/23991"></a>
```
1. "sudo apt install gnome-tweaks"

2. "gnome-tweaks"

3. go to "Keyboard & Mouse" and click on "Additional Layout Options"

4. inside "Caps Lock Behavior" choose "Make Caps Lock an Additional Esc"

5. go to vscode "File" then "Preferences" then "Settings"

6. Type "dispatch"

7. choose "keyCode"

8. done
```


*** Couldn't get to apply after restart, nor did it work for VS Code.
## Remap Keys
[[os_install_linux/.remap_keys.sh|.remap_keys.sh]]
[[os_install_linux/.remap_caps_to_esc|.remap_caps_to_esc]]
[[os_install_linux/.remap_caps_to_caps|.remap_caps_to_caps]]

### Persist key remap across rebotts

Make sure desired key mapping is in affect.

```
xkbcomp $DISPLAY $HOME/.xkbmap
// Note: Last param (":0") can be sourced from running 'who' command.
xkbcomp /home/user/.xkbmap ":0"
```

<a id="change-open-in-terminal"></a>
### Change 'Open in Terminal' context menu target (Tilix)

https://unix.stackexchange.com/questions/547492/change-ubuntu-18-04-nautilus-context-menu-open-in-terminal-from-gnome-termina

```
1. Run apt install filemanager-actions.

2. Run FileManager-Actions app.

3. Open File -> New Action.

4.1 Action tab: Mark Display item in location context menu
4.2  Command tab:
	Path: /usr/bin/tilix
  Parameters: --working-directory=%d/%b
  Working directory: %d

5. Navigate to Edit -> Preferences -> Runtime preferences (tab) -> Nautilus menu layout | uncheck:
	 Create a root 'FileManger-Actions' menu  

 5. Restart Nautilus (terminal: 'nautilus -q && nautilus &')
 ```
 
 <a id="setup-wacom-tablet"></a>
 ### Setup Wacom Tablet (Intuous 4)

https://itectec.com/ubuntu/ubuntu-wacom-tablet-middle-mouse-button-scrolling/ 
https://github.com/linuxwacom/xf86-input-wacom/wiki/xsetwacom
https://askubuntu.com/questions/183354/configuring-wacom-tablet-buttons-and-options
https://www.linux-magazine.com/Issues/2018/212/xsetwacom

List modifiers
```
xsetwacom --list modifiers
```

To reset button don’t include final param eg.
```
xsetwacom –set 11 Button 1 [] // ([] = nothing)
```

Lower button (larger button on pen) is 'Button 3'
Upper button (smaller button on pen) is 'Button 2'

Setup scrolling
```
(Note 11 is the device ID [stylus] below)
xsetwacom --set 11 Button 2 "pan"
```

Set scrolling sensitivity
```
xsetwacom --set 11 "PanScrollThreshold" 300
```

Set pen movement distance before scroll events are fired.
```
xsetwacom --set 11 "ScrollDistance" 0
```

### Config table area
List devices
```
xsetwacom --list devices 
```
e.g. output
> Wacom Intuos Pro M Finger touch 	id: 26	type: TOUCH     
> Wacom Intuos Pro M Pen stylus   	id: 27	type: STYLUS    
> Wacom Intuos Pro M Pen eraser   	id: 28	type: ERASER    
> Wacom Intuos Pro M Pad pad      	id: 29	type: PAD  

Set table area (when using the stylus) use device type: STYLUS.
i.e. in the above example output the device to set would be 27
```
xsetwacom --set 27 area 0 0 34800 20000
```
Reset tablet area
```
xsetwacom --set 27 ResetArea
```


