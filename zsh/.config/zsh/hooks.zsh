# Set window title according to directory
function set_win_title() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    local my_hostname="${MY_HOSTNAME:-$(hostname)}"
    echo -ne "\033]0;$(basename "$PWD") @${my_hostname}\007"
  else
    echo -ne "\033]0;$(basename "$PWD")\007"
  fi
}

# Refresh tmux related environment, used for a session shared with local & remote machine
function renv() {
  eval $(tmux show-env -s)
}

# Beep notification, better used with tmux "monitor-bell" option
function bell() {
  printf '\a'
}

function bell_checked() {
  if [[ -n "$NOTIFY_BELL" ]]; then
    bell
  fi
}

if [[ ! -v TMUX ]]; then
  precmd_functions+=(set_win_title)
else
  preexec_functions+=(renv)
fi

precmd_functions+=(bell_checked)
