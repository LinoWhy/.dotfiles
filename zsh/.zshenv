# User configurations are read under $ZDOTDIR, or $HOME if $ZDOTDIR is not set.

# Configurations are sourced in the following sequence.
# .zshenv: [Read every time], so only set environment variables
# .zprofile: [Read at login]
# .zshrc: [Read when interactive]
# .zlogin: [Read at login], just after .zshrc
# .zlogout: [Read at logout][Within login shell]

# NOTE: Terminals in NEOVIM or TMUX will not source this file!!!

# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# ZSH
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# editor
export EDITOR=nvim
export VISUAL="nvim"
export MANPAGER='nvim +Man!'

# PATH
export PATH="$HOME/.local/bin:$PATH"

# homebrew
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

# rust
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"

# repo
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo'

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# linux input method
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# ensure compile_commands.json is always generated
export CMAKE_EXPORT_COMPILE_COMMANDS=1

# ensure truecolor over SSH
export COLORTERM=truecolor
