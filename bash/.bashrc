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
alias cat='bat -p'
alias f='fzf'
alias fdd='fd --hidden --no-ignore'
alias g='git'
alias hex='hexyl'
alias lzd='lazydocker'
alias lzg='lazygit'
alias nv='nvim'
alias open='xdg-open'
alias sudoo='sudo -E'
alias t='tmux'

# ls
alias l='lsd -l'
alias la='lsd -lA'
alias lf='lsd -l --group-directories-first'
alias ll='lsd -lAL'
alias ls='lsd'
alias lt='lsd --tree'
alias lta='lsd --tree -a'
alias ltt='lsd --tree --depth'

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'

# git
git_log_format="%C(auto)%h%d %s %C(black)%C(bold)%cr%Creset %Cblue[%cn]"
alias gb='git branch'
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gcs='git commit -s'
alias gch='git cherry-pick'
alias gl='git log'
alias gls="git log --pretty=format:'$git_log_format' --graph"
alias gla="git log --pretty=format:'$git_log_format' --graph --all"
alias gll="git log --pretty=format:'$git_log_format' --graph --all --numstat"
alias GP='git push'
alias glf='git log --pretty=fuller'
alias gp='git pull'
alias gpra='git pull --rebase --autostash'
alias gr='git remote'
alias gsh='git stash'
alias gst='git status'
alias gsw='git switch'

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

################################################################################
# Other tools
################################################################################
[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# vivid to generate colorized output
export LS_COLORS="$(vivid generate catppuccin-mocha)"

eval "$(zoxide init --hook prompt bash)"
eval "$(starship init bash)"
