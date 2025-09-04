source <(fzf --zsh)

# preview files and directories as default
export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore"
export FZF_DEFAULT_OPTS="-i --height 40% --layout=reverse --info=inline
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796
--color=selected-bg:#494D64
--color=border:#363A4F,label:#CAD3F5
--bind='alt-k:preview-up'
--bind='alt-j:preview-down'
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'"
# --preview='$ZDOTDIR/helpers/fzf-previewer.sh ./{}'"

# default options
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview='$ZDOTDIR/helpers/fzf-previewer.sh ./{}'"

# preview for long commands
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap --height ~50%"

# enable copy with "Ctrl-Y"
if [[ $(ostype) == "wsl" ]]; then
  export FORGIT_COPY_CMD="win32yank.exe -i --crlf"
elif [[ $(ostype) == "linux" ]]; then
  export FORGIT_COPY_CMD="xclip -selection clipboard"
fi

# disable git graph for faster reaction in huge git repository
export FORGIT_LOG_GRAPH_ENABLE=0

export FORGIT_STASH_FZF_OPTS='
--bind="ctrl-d:reload(git stash drop $(cut -d: -f1 <<<{}) 1>/dev/null && git stash list)"
'

export FORGIT_FZF_DEFAULT_OPTS="
--height='80%'
--layout=reverse
--info=inline
--bind='alt-k:preview-up'
--bind='alt-j:preview-down'
--bind='ctrl-r:toggle-all'
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'
--preview-window='right:50%'"

# fzf-tab configs
# https://github.com/Aloxaf/fzf-tab#oh-my-zsh
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#363A4F,label:#CAD3F5

# find-in-file - usage: fif <searchTerm>
# 1. grep strings with ripgrep
# 2. filter with fzf, preview and multi-select enabled
# 3. send selected locations to nvim quickfix and open it
fif() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: fif <searchTerm>"
    return 1
  fi

  # use "@" to get each parameter as a separate word
  local rg_results=$(rg --color=always --vimgrep "$@")
  [[ -z $rg_results ]] && return 0

  local selected=$(echo "$rg_results" |
    fzf --prompt="rg \"${*:-}\" >" --ansi \
        --multi --bind ctrl-a:select-all \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat -p --color=always {1} --highlight-line {2}' \
        --preview-window '+{2}-5'
  )
  [[ -z $selected ]] && return 0

  nvim -q <(echo "$selected")
}

function fa() {
  alias | fzf -m --preview "" --prompt='alias > ' --bind ctrl-a:select-all
}

function fm() {
 man -k . | fzf -d "-" -n 1 --preview "" --prompt='man > ' | tr '()' ' ' | awk '{print $2, $1}' | xargs -r man
}

function ft() {
  tldr -l | fzf --preview "" --prompt='tldr > ' --bind "enter:become(echo tldr {} && tldr {})"
}
