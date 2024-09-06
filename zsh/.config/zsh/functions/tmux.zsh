# Refresh tmux related environment, used for a session shared with local & remote machine
function renv() {
  eval $(tmux show-env -s)
}

# Select a tmux session and change or attach to
function tt() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux $change -t "$session"
}
