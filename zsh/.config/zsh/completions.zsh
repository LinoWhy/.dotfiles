# Completion path priority:
# 1) Homebrew completions
# 2) Personal completions
typeset -gU fpath
fpath=("$ZDOTDIR/completions" $fpath)
[[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]] && \
  fpath=("${HOMEBREW_PREFIX}/share/zsh/site-functions" $fpath)

# case insensitive completion, partial-word with [._-] and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# load completion
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Reference: https://zsh.sourceforge.io/Guide/zshguide06.html
