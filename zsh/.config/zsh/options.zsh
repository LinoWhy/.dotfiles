setopt NO_BEEP
setopt AUTO_CD
# setopt GLOB_DOTS                 # Match filename with leading "."

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY        # New history lines are added to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
# setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
# setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
# setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

if [ ! -f "$HISTFILE" ]; then
  touch "$HISTFILE"
fi

# Set word separators: '/'
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Directory Stack
setopt AUTO_PUSHD                # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.

# Use vivid to generate colorized output
export LS_COLORS="$(vivid generate catppuccin-mocha)"

# Set window title according to directory
precmd_functions+=(set_win_title)
