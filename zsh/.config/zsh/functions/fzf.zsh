[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# preview files and directories as default
export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore"
export FZF_DEFAULT_OPTS="-i --height 40% --layout=reverse --info=inline
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
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
if isWsl; then
  export FORGIT_COPY_CMD="win32yank.exe -i --crlf"
else
  export FORGIT_COPY_CMD="xclip -selection clipboard"
fi

export FORGIT_FZF_DEFAULT_OPTS="
--height='80%'
--layout=reverse
--info=inline
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
--bind='alt-k:preview-up'
--bind='alt-j:preview-down'
--bind='ctrl-r:toggle-all'
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'
--preview-window='right:60%'"

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
zstyle ':fzf-tab:*' fzf-flags --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
  --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796

# configs form https://github.com/junegunn/fzf/wiki/examples
# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
function fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  IFS=$'\n' files=($(rg --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
    | fzf --multi --select-1 --preview="rg --ignore-case --pretty --context 10 '"$*"' {}"))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}

function fa() {
  alias | fzf --preview "" --prompt='alias > '
}

function fm() {
  man -k . | fzf --preview "" --prompt='man > ' --bind "enter:become(echo man {1}{2} && man {1}{2})"
}

function ft() {
  tldr -l | fzf --preview "" --prompt='tldr > ' --bind "enter:become(echo tldr {} && tldr {})"
}
