# Set completion path
fpath=($ZDOTDIR/completions $fpath)

# case insensitive completion, partial-word with [._-] and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# load completion
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Reference: https://zsh.sourceforge.io/Guide/zshguide06.html
