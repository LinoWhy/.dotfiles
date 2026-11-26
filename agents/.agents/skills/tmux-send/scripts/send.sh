#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || -z $1 ]]; then
  printf 'Usage: %s TARGET_PANE < message.txt\n' "${0##*/}" >&2
  exit 2
fi

target=$1
message=$(cat)
if [[ ! $message =~ [^[:space:]] ]]; then
  printf 'Message must contain text.\n' >&2
  exit 2
fi

if [[ $message == *$'\n'* && $(tmux display-message -p "-t$target" '#{bracket_paste_flag}') != 1 ]]; then
  printf 'Target pane %s requires bracketed paste for multiline text.\n' "$target" >&2
  exit 1
fi

buffer="tmux-send-$$-$RANDOM"
if ! printf '%s' "$message" | tmux load-buffer -b "$buffer" - \; \
  paste-buffer -dpr -b "$buffer" "-t$target" \; \
  send-keys "-t$target" Enter; then
  tmux delete-buffer -b "$buffer" 2>/dev/null || true
  exit 1
fi
