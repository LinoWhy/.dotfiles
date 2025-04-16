export KEYTIMEOUT=10

# Use emacs key bindings
bindkey -e

bindkey -s '^[l' 'clear^M'

# backward-kill-line rather than kill-whole-line
bindkey \^U backward-kill-line

# [PageUp] - Up a line of history
bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
# [PageDown] - Down a line of history
bindkey -M emacs "${terminfo[knp]}" down-line-or-history

# [Home], [End] & [Delete]
bindkey "^[[H"  beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[3~" delete-char

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^[e' edit-command-line
