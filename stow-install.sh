#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 [-n]"
}

stow_args=(-v)

while (($#)); do
  case "$1" in
    -n)
      stow_args+=("-n")
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

cd "$(dirname "$0")"

TARGET_DIRS=(
  agents/skills
  cargo
  claude/skills
  codex
  gemini/config
)

# Keep these directories available for other installers and client state.
for target_dir in "${TARGET_DIRS[@]}"; do
  mkdir -p "$HOME/.$target_dir"
done

stow "${stow_args[@]}" */
