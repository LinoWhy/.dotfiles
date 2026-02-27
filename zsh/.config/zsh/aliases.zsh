alias bsh='env -i HOME="$HOME" TERM="$TERM" bash'
alias cat='bat -p'
alias f='fzf'
alias fdd='fd --hidden --no-ignore'
alias g='git'
alias hex='hexyl'
alias lzd='lazydocker'
alias lzg='lazygit'
alias nv='nvim'
alias sudoo='sudo -E'
alias t='tmux'
alias z='__zoxide_zi'

# ls
alias l='lsd -l'
alias la='lsd -lA'
alias lf='lsd -l --group-directories-first'
alias ll='lsd -lAL'
alias ls='lsd'
alias lt1='lsd --tree --depth 1'
alias lt2='lsd --tree --depth 2'
alias lt3='lsd --tree --depth 3'
alias lt4='lsd --tree --depth 4'
alias lt5='lsd --tree --depth 5'

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
alias gls="git log --pretty=format:'$git_log_format'"
alias gla="git log --pretty=format:'$git_log_format' --all --graph"
alias gll="git log --pretty=format:'$git_log_format' --numstat"
alias glf='git log --pretty=fuller'
alias GP='git push'
alias gp='git pull'
alias gpra='git pull --rebase --autostash'
alias gr='git remote'
alias gsh='git stash'
alias gst='git status -sb'
alias gsw='git switch'
alias gwt='git worktree'

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
