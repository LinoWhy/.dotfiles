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

PACKAGES=(
  agents
  cargo
  claude/skills
  codex/skills
)

# only link subfolders
for PKG in "${PACKAGES[@]}"; do
  mkdir -p "$HOME/.${PKG}"
done

stow "${stow_args[@]}" */
