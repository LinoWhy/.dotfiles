[ -f "${XDG_DATA_HOME}/zap/zap.zsh" ] && source "${XDG_DATA_HOME}/zap/zap.zsh"

# Detect environment first
source "$ZDOTDIR/env.zsh"

# Homebrew shellenv
if command -v brew >/dev/null 2>&1; then
  eval "$($(brew --prefix)/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Personal configurations
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/keys.zsh"
source "$ZDOTDIR/aliases.zsh"

# Additional configuration files
for file in $ZDOTDIR/functions/*; do
  source $file
done

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
source "$ZDOTDIR/helpers/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
plug "zsh-users/zsh-syntax-highlighting"

# Setup zsh hooks
source "$ZDOTDIR/hooks.zsh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# End of Configuration
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS -1" # Jump to the only match directly
eval "$(zoxide init zsh --no-cmd)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
