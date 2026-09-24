# Prompt configured using starship (~/.config/starship.toml)
#PROMPT='(%m) %1d$ '

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/josh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

n()
{
  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi
  
  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  nnn -Rd "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}

# Update PATH with deno executable.
path=('/home/josh/.deno/bin' $path)
export PATH 

eval "$(starship init zsh)"

### ls highlighting ###
eval `dircolors /home/josh/.zsh/dircolors.256dark`

### Syntax highlighting ###
source /home/josh/.zsh/dracula-theme.sh
source /home/josh/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
