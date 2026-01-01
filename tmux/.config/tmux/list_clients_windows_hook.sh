#!/usr/bin/env bash
set -euo pipefail

client_tty="${1:-}"
if [ -z "$client_tty" ]; then
  exit 0
fi

hook_session=$(tmux display-message -p -t "$client_tty" "#{session_name}" 2>/dev/null || true)
[ -n "$hook_session" ] || exit 0

data=$(tmux list-windows -t "$hook_session" -F $'#{session_name}\t#{window_index}\t#{window_active}\t#{pane_current_path}\t#{E:@window_flags_icons}' 2>/dev/null || true)
[ -n "$data" ] || exit 0

payload=$(printf "%s" "$data" | base64 -w 0)
printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" tmux_windows "$payload" >"$client_tty"
