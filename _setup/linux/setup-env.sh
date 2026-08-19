#!/usr/bin/env bash
# setup-env.sh
# Bootstrap a portable env directory with config files and static binaries.
#
# Usage: ./setup-env.sh [OPTIONS]
#   -d, --dest DIR   target env directory (default: ~/env)
#   -n, --dry-run    pass through to install-static-tools.sh, no file changes
#   -f, --force      reinstall binaries even if already up to date
#   -h, --help       show this help

set -uo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  printf 'This script is for Linux only.\n' >&2
  exit 1
fi

DEST="${HOME}/env"
DRY_RUN=false
FORCE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--dest)  DEST="$2"; shift ;;
    -n|--dry-run) DRY_RUN=true ;;
    -f|--force)   FORCE=true ;;
    -h|--help)  sed -n '2,9p' "$0" | sed 's/^# \?//'; exit 0 ;;
    -*) printf 'Unknown option: %s\n' "$1" >&2; exit 1 ;;
  esac
  shift
done

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
SRC="${SCRIPT_DIR}/env"

# ── Colors ────────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  Gr='\033[0;32m' Cy='\033[0;36m' Bo='\033[1m' No='\033[0m'
else
  Gr='' Cy='' Bo='' No=''
fi

log() { printf "${Cy}→${No} %s\n" "$*"; }
ok()  { printf "  ${Gr}✓${No} %s\n" "$*"; }

# ── Deploy config files ───────────────────────────────────────────────────────
log "dest: ${Bo}${DEST}${No}"

if ! $DRY_RUN; then
  mkdir -p \
    "${DEST}/bin" \
    "${DEST}/config/lsd" \
    "${DEST}/config/tmux" \
    "${DEST}/etc" \
    "${DEST}/cache" \
    "${DEST}/share" \
    "${DEST}/state"

  cp "${SRC}/etc/bashrc"                "${DEST}/etc/bashrc"
  cp "${SRC}/bin/env-bash"              "${DEST}/bin/env-bash"
  cp "${SRC}/config/starship.toml"      "${DEST}/config/starship.toml"
  cp "${SRC}/config/lsd/config.yaml"    "${DEST}/config/lsd/config.yaml"
  cp "${SRC}/config/tmux/tmux.conf"     "${DEST}/config/tmux/tmux.conf"
  chmod +x "${DEST}/bin/env-bash"

  ok "config files deployed to ${DEST}"
else
  log "dry-run: skipping config file deploy"
fi

# ── Install static binaries ───────────────────────────────────────────────────
printf '\n'
log "installing binaries → ${Bo}${DEST}/bin${No}\n"

TOOL_SCRIPT="${SCRIPT_DIR}/install-static-tools.sh"
if [[ ! -x "$TOOL_SCRIPT" ]]; then
  printf 'install-static-tools.sh not found next to setup-env.sh\n' >&2
  exit 1
fi

args=("--dest" "${DEST}/bin")
$DRY_RUN && args+=("--dry-run")
$FORCE   && args+=("--force")

"$TOOL_SCRIPT" "${args[@]}"

# ── Done ──────────────────────────────────────────────────────────────────────
if ! $DRY_RUN; then
  printf '\n'
  ok "done. start with: ${Bo}${DEST}/bin/env-bash${No}"
fi
