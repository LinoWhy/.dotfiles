#!/usr/bin/env bash
set -euo pipefail

script_path=$(readlink -f "$0" 2>/dev/null || printf "%s" "$0")

is_running() {
  pgrep -f "$script_path --daemon" >/dev/null 2>&1
}

list_windows() {
  mapfile -t client_ttys < <(tmux list-clients -F '#{client_tty}' 2>/dev/null | sed '/^$/d')
  ((${#client_ttys[@]} > 0)) || return 0

  cpu=""
  mem=""
  if [ -x "$HOME/.local/share/tmux/plugins/tmux-cpu/scripts/cpu_percentage.sh" ]; then
    cpu=$("$HOME/.local/share/tmux/plugins/tmux-cpu/scripts/cpu_percentage.sh" 2>/dev/null || true)
  fi
  if [ -x "$HOME/.local/share/tmux/plugins/tmux-cpu/scripts/ram_percentage.sh" ]; then
    mem=$("$HOME/.local/share/tmux/plugins/tmux-cpu/scripts/ram_percentage.sh" 2>/dev/null || true)
  fi
  cpu=${cpu%\%}
  mem=${mem%\%}
  stats=""
  if [ -n "$cpu" ] || [ -n "$mem" ]; then
    stats="cpu=${cpu} mem=${mem}"
  fi

  for tty in "${client_ttys[@]}"; do
    data=$(tmux list-windows -t "$tty" -F $'#{session_name}\t#{window_index}\t#{window_active}\t#{pane_current_path}\t#{E:@window_flags_icons}')
    [ -z "$data" ] && continue

    payload=$(printf "%s" "$data" | base64 -w 0)
    printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" tmux_windows "$payload" > "$tty"

    stats_payload=$(printf "%s" "$stats" | base64 -w 0)
    printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" tmux_stats "$stats_payload" > "$tty"
  done
}

if [[ "${1:-}" != "--daemon" ]]; then
  if is_running; then
    exit 0
  fi
  nohup "$script_path" --daemon >/dev/null 2>&1 &
  exit 0
fi

while true; do
  list_windows
  sleep 0.1
done
