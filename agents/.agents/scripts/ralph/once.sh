#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
agent="${1:-codex}"

issues=$(cat _issues/*.md 2>/dev/null || echo "No issues found")
commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
prompt=$(cat "$script_dir/prompt.md")

case "$agent" in
  codex)
    codex "Previous commits: $commits Issues: $issues $prompt"
    ;;
  claude)
    ept claude --permission-mode bypassPermissions "Previous commits: $commits Issues: $issues $prompt"
    ;;
  *)
    echo "Usage: $0 [codex|claude]" >&2
    exit 2
    ;;
esac
