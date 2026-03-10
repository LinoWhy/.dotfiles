# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

################################################################################
# Options
################################################################################
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

################################################################################
# Aliases
################################################################################
# ls
alias l='lsd -l'
alias la='lsd -lA'
alias lf='lsd -l --group-directories-first'
alias ll='lsd -lAL'
alias ls='lsd'
alias lt='lsd --tree'
alias lta='lsd --tree -a'
alias ltt='lsd --tree --depth'

# git
git_log_format="%C(auto)%h%d %s %C(black)%C(bold)%cr%Creset %Cblue[%an]" # relative commit data & author name
alias gb='git branch'
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gcs='git commit -s'
alias gch='git cherry-pick'
alias gl='git log'
alias gls="git log --pretty=format:'$git_log_format'"
alias gla="git log --pretty=format:'$git_log_format' --all --graph"
alias gll="git log --pretty=format:'$git_log_format' --numstat"
alias glf='git log --pretty=fuller'
alias gp='git pull'
alias GP='git push'
alias gpra='git pull --rebase --autostash'
alias gr='git remote'
alias gsh='git stash'
alias gst='git status'
alias gsw='git switch'
alias gwt='git worktree'

# repo
alias rsb='repo forall -pc git branch -vv'
alias rss='repo sync -j$(nproc)'
alias rst='repo status'

################################################################################
# Functions
################################################################################
# push to current tracking remote branch on gerrit
function ggp() {
    remote_name=$(git remote)
    branch_name=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} | awk -F/ '{print $2}')

    # Check if branch name is non-empty
    if [[ -n "$branch_name" ]]; then
        git push $remote_name HEAD:refs/for/$branch_name
    else
        echo "Error: Cannot determine the remote branch to push."
    fi
}

# detect lfs repo and pull under $1 or $PWD
function gplfs() {
    local directory="${1:-$PWD}"
    rg -l -F "merge=lfs" --glob=".gitattributes" | while IFS= read -r line; do
        local dir=$(dirname "$line")
        echo "git lfs pull for \"$dir\""
        (cd "$dir" || exit ; git lfs pull)
    done
}

function bell() {
  printf '\a'
}

function bell_checked() {
  if [[ -n "$NOTIFY_BELL" ]]; then
    bell
  fi
}

################################################################################
# Environment
################################################################################
# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# editor
export EDITOR=nvim
export VISUAL="nvim"
export MANPAGER='nvim +Man!'

export PATH="$HOME/.local/bin:$PATH"

# ensure compile_commands.json is always generated
export CMAKE_EXPORT_COMPILE_COMMANDS=1

# ensure truecolor over SSH
export COLORTERM=truecolor

################################################################################
# Other tools
################################################################################
eval "$(fzf --bash)"

# vivid to generate colorized output
export LS_COLORS="$(vivid generate catppuccin-mocha)"

eval "$(zoxide init --hook prompt bash)"
eval "$(starship init bash)"
PROMPT_COMMAND="bell_checked; $PROMPT_COMMAND"
