#!/bin/bash
set -eo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <iterations>"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for ((i = 1; i <= "$1"; i++)); do
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  last_message_file="$tmpdir/last-message.txt"

  commits="$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")"
  issues="$(cat _issues/*.md 2>/dev/null || echo "No issues found")"
  prompt="$(cat "$script_dir/prompt.md")"

  codex exec \
    --json \
    -o "$last_message_file" \
    "Previous commits: $commits Issues: $issues $prompt"

  if [ -f "$last_message_file" ] && rg -q "<promise>NO MORE TASKS</promise>" "$last_message_file"; then
    echo "Ralph complete after $i iterations."
    exit 0
  fi

  rm -rf "$tmpdir"
  trap - EXIT
done
