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
alias z='__zoxide_zi'

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
git_log_format="%C(auto)%h%d %s %C(black)%C(bold)%cr%Creset %Cblue[%an]" # relative commit data & author name
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
alias rss='repo sync'
alias rst='repo status'

# Directory Stack
alias d='dirs -v'
for index ({0..9}) alias "$index"="cd +${index}"; unset index

alias -- -='cd -'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias md='mkdir -p'
alias rd=rmdir
