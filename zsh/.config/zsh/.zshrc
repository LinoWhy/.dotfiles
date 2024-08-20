[ -f "${XDG_DATA_HOME}/zap/zap.zsh" ] && source "${XDG_DATA_HOME}/zap/zap.zsh"

# Detect environment first
source "$ZDOTDIR/env.zsh"

# Personal configurations
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/keys.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/extract.zsh"

# Git commands with fzf
plug "wfxr/forgit"

# use gencomp <cmd> to generate completion functions from getopt-style help texts
GENCOMPL_FPATH="$ZDOTDIR/completions"
zstyle :plugin:zsh-completion-generator programs btm duf fzf hexyl lsd procs yazi
plug "RobSis/zsh-completion-generator"

# Set, load and initialise completion system
source "$ZDOTDIR/completions.zsh"

# fzf-tab needs to be loaded after compinit, but before plugins which will wrap widgets,
# such as zsh-autosuggestions or fast-syntax-highlighting
plug "Aloxaf/fzf-tab"
plug "zsh-users/zsh-autosuggestions"

# Load colorsheme before loading zsh-syntax-highlighting
source "$ZDOTDIR/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
plug "zsh-users/zsh-syntax-highlighting"

# End of Configuration
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"