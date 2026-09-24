
# Zsh
Terminal emulator language.

## Links
https://apple.stackexchange.com/questions/388622/zsh-zprofile-zshrc-zlogin-what-goes-where

## Order of config loading
.zshenv → .zprofile → .zshrc → .zlogin → .zlogout

## Config description

<p>For an excellent, in-depth explanation of what these files do, see <a href="https://unix.stackexchange.com/q/71253/107777">What should/shouldn't go in .zshenv, .zshrc, .zlogin, .zprofile,</a> on Unix/Linux.</p>

|Config|Description|
|---|---|
|.zprofile (.zlogin) |.zlogin and .zprofile are basically the same thing - they set the environment for login shells; they just get loaded at different times (see below). .zprofile is based on the Bash's .bash_profile while .zlogin is a derivative of CSH's .login. Since Bash was the default shell for everything up to Mojave, stick with .zprofile.

.zshrc |This sets the environment for interactive shells. This gets loaded after .zprofile. It's typically a place where you "set it and forget it" type of parameters like $PATH, $PROMPT, aliases, and functions you would like to have in both login and interactive shells.
| .zshenv (Optional) | This is read first and read every time. This is where you set environment variables. I say this is optional because is geared more toward advanced users where having your $PATH, $PAGER, or $EDITOR variables may be important for things like scripts that get called by launchd. Those run under a non-interactive shell so anything in .zprofile or .zshrc won't get loaded. Personally, I don't use this one because I set the PATH variable in my script itself to ensure portability. |
| .zlogout (Optional) | But very useful! This is read when you log out of a session and is very good for cleaning things up when you leave (like resetting the Terminal Window Title) |
| | |
| | |

### zsh extensions
**Customise shell prompt**
https://starship.rs/

**Add syntac highlighting (applies to command currently being written).**
https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
https://draculatheme.com/zsh-syntax-highlighting

Edit zsh-syntax-highlighting.zsh to show cursor correctly when moving left/right
https://github.com/zsh-users/zsh-syntax-highlighting/issues/171

% ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
% typeset -A ZSH_HIGHLIGHT_STYLES    
% ZSH_HIGHLIGHT_STYLES=(cursor bold)
% source zsh-syntax-highlighting.zsh

**Add ls highlighting**
https://github.com/seebi/dircolors-solarized
