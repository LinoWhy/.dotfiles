#!/usr/bin/env bash
# install-static-tools.sh
# Download latest musl static Linux binaries from GitHub releases
#
# Usage: ./install-static-tools.sh [OPTIONS] [TOOL...]
#   -n, --dry-run        show version status without installing
#   -f, --force          reinstall even if already up to date
#   -d, --dest DIR       install directory (default: ~/.local/bin)
#   -h, --help           show this help
#   GITHUB_TOKEN         set to raise API rate limit (60 → 5000 req/h)

set -uo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  printf 'This script is for Linux only.\n' >&2
  exit 1
fi

INSTALL_DIR="${HOME}/.local/bin"
DRY_RUN=false
FORCE=false
FILTER=()

# ── Colors ────────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  Rd='\033[0;31m' Gr='\033[0;32m' Ye='\033[1;33m' Cy='\033[0;36m'
  Bo='\033[1m'    Di='\033[2m'    No='\033[0m'
else
  Rd='' Gr='' Ye='' Cy='' Bo='' Di='' No=''
fi

# ── Arg parsing ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=true ;;
    -f|--force)   FORCE=true ;;
    -d|--dest)    INSTALL_DIR="$2"; shift ;;
    -h|--help)    sed -n '2,10p' "$0" | sed 's/^# \?//'; exit 0 ;;
    -*)           printf 'Unknown option: %s\n' "$1" >&2; exit 1 ;;
    *)            FILTER+=("$1") ;;
  esac
  shift
done

# ── Tool definitions ──────────────────────────────────────────────────────────
# Fields: name | repo | asset_template | archive_type | bin_name_in_archive
#
# asset_template tokens:
#   {TAG}  full git tag as-is   (e.g. "v0.26.1" or "15.2.0")
#   {VER}  tag with leading 'v' stripped  (e.g. "0.26.1")
#
# archive_type:
#   tgz  .tar.gz — extract all, find binary by bin_name (default: name)
#   zip  .zip    — same
#   gz   single gzip-compressed binary — decompress, install as name
#   bin  single uncompressed binary — copy directly, install as name
#
# bin_name_in_archive (5th field):
#   For tgz/zip: filename of binary inside archive (empty = same as name)
#   For gz/bin:  unused, leave empty
TOOLS=(
  "bat|sharkdp/bat|bat-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "btm|ClementTsang/bottom|bottom_x86_64-unknown-linux-musl.tar.gz|tgz|"
  "delta|dandavison/delta|delta-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "direnv|direnv/direnv|direnv.linux-amd64|bin|"
  "duf|muesli/duf|duf_{VER}_linux_x86_64.tar.gz|tgz|"
  "dust|bootandy/dust|dust-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "fd|sharkdp/fd|fd-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "fzf|junegunn/fzf|fzf-{VER}-linux_amd64.tar.gz|tgz|"
  "hexyl|sharkdp/hexyl|hexyl-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "lsd|lsd-rs/lsd|lsd-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "macchina|Macchina-CLI/macchina|macchina-{TAG}-linux-musl-x86_64.tar.gz|tgz|"
  "nvim|neovim/neovim-releases|nvim-linux-x86_64.tar.gz|tgz|"
  "procs|dalance/procs|procs-{TAG}-x86_64-linux.zip|zip|"
  "rg|BurntSushi/ripgrep|ripgrep-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "starship|starship/starship|starship-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "tldr|tealdeer-rs/tealdeer|tealdeer-linux-x86_64-musl|bin|"
  "vivid|sharkdp/vivid|vivid-{TAG}-x86_64-unknown-linux-musl.tar.gz|tgz|"
  "yazi|sxyazi/yazi|yazi-x86_64-unknown-linux-musl.zip|zip|"
  "zoxide|ajeetdsouza/zoxide|zoxide-{VER}-x86_64-unknown-linux-musl.tar.gz|tgz|"
)

# ── Helpers ───────────────────────────────────────────────────────────────────

curl_gh() {
  local -a hdr=(-fsSL)
  [[ -n "${GITHUB_TOKEN:-}" ]] && hdr+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  curl "${hdr[@]}" "$@"
}

latest_tag() {
  local repo="$1"
  # First try: follow the /releases/latest redirect — no auth, no rate limit
  local loc
  loc=$(curl -sSI "https://github.com/${repo}/releases/latest" \
    | grep -i '^location:' | tr -d '\r' | sed 's|.*/||')
  if [[ -n "$loc" ]]; then
    printf '%s' "$loc"
    return 0
  fi
  # Fallback: GitHub API (needs GITHUB_TOKEN when rate-limited)
  local resp
  resp=$(curl_gh "https://api.github.com/repos/${repo}/releases/latest") || return 1
  printf '%s' "$resp" \
    | grep -o '"tag_name": *"[^"]*"' \
    | grep -o '"[^"]*"$' \
    | tr -d '"'
}

strip_v() { printf '%s' "${1#v}"; }
semver()  { printf '%s' "$1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1; }
tmpl()    { local s="${1//\{TAG\}/${2}}"; printf '%s' "${s//\{VER\}/${3}}"; }

installed_ver() {
  local bin="${INSTALL_DIR}/$1"
  [[ -x "$bin" ]] || { printf ''; return 0; }
  local out=''
  out=$(timeout 3 "$bin" --version 2>&1) \
    || out=$(timeout 3 "$bin" -V 2>&1) \
    || out=''
  semver "$out"
}

in_filter() {
  local needle="$1" f
  for f in "${FILTER[@]}"; do [[ "$needle" == "$f" ]] && return 0; done
  return 1
}

# ── Process one tool ──────────────────────────────────────────────────────────

process_tool() {
  local name="$1" repo="$2" asset_tpl="$3" arc="$4" bin_name="${5:-}"
  [[ -z "$bin_name" ]] && bin_name="$name"

  # Fetch latest tag
  local tag
  if ! tag=$(latest_tag "$repo"); then
    printf "  ${Rd}✗${No} %-14s could not fetch release info\n" "$name"
    return 0
  fi
  local ver;    ver=$(strip_v "$tag")
  local latest; latest=$(semver "$ver" || printf '%s' "$ver")

  # Installed version
  local installed; installed=$(installed_ver "$name")

  # Status line
  if [[ -z "$installed" ]]; then
    printf "  ${Ye}+${No} ${Bo}%-14s${No}  not installed  →  ${Gr}%s${No}\n" "$name" "$latest"
  elif [[ "$installed" == "$latest" ]]; then
    printf "  ${Gr}✓${No} %-14s  ${Di}%s${No}\n" "$name" "$installed"
    $FORCE || return 0
  else
    printf "  ${Ye}↑${No} ${Bo}%-14s${No}  ${Ye}%s${No}  →  ${Gr}%s${No}\n" "$name" "$installed" "$latest"
  fi

  $DRY_RUN && return 0

  # Download
  local asset; asset=$(tmpl "$asset_tpl" "$tag" "$ver")
  local url="https://github.com/${repo}/releases/download/${tag}/${asset}"
  local tmpdir; tmpdir=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '${tmpdir}'" RETURN

  printf "    ${Cy}↓${No} %s\n" "$asset"
  local archive="${tmpdir}/${asset}"
  if ! curl_gh -o "$archive" "$url"; then
    printf "    ${Rd}✗${No} download failed: %s\n" "$url"
    return 0
  fi

  # Extract
  local dest="${tmpdir}/_out"
  case "$arc" in
    tgz)
      tar -xzf "$archive" -C "$tmpdir" 2>/dev/null
      local found
      found=$(find "$tmpdir" -name "$bin_name" -type f | head -1)
      if [[ -z "$found" ]]; then
        printf "    ${Rd}✗${No} binary '%s' not found in archive\n" "$bin_name"
        return 0
      fi
      mv "$found" "$dest"
      ;;
    zip)
      unzip -q -o "$archive" -d "$tmpdir" 2>/dev/null
      local found
      found=$(find "$tmpdir" -name "$bin_name" -type f | head -1)
      if [[ -z "$found" ]]; then
        printf "    ${Rd}✗${No} binary '%s' not found in archive\n" "$bin_name"
        return 0
      fi
      mv "$found" "$dest"
      ;;
    gz)
      gunzip -c "$archive" > "$dest"
      ;;
    bin)
      mv "$archive" "$dest"
      ;;
  esac

  mkdir -p "$INSTALL_DIR"
  chmod +x "$dest"
  mv "$dest" "${INSTALL_DIR}/${name}"
  printf "    ${Gr}✓${No} %s  →  %s/%s\n" "$latest" "$INSTALL_DIR" "$name"
}

# ── Main ──────────────────────────────────────────────────────────────────────

if $DRY_RUN; then
  printf "${Cy}→${No} dry-run: checking versions, no changes\n\n"
else
  printf "${Cy}→${No} install dir: %s\n\n" "$INSTALL_DIR"
fi

for spec in "${TOOLS[@]}"; do
  IFS='|' read -r t_name t_repo t_asset t_arc t_bin <<< "$spec"
  [[ ${#FILTER[@]} -gt 0 ]] && ! in_filter "$t_name" && continue
  process_tool "$t_name" "$t_repo" "$t_asset" "$t_arc" "$t_bin" || true
done

printf '\n'
$DRY_RUN && printf "${Cy}→${No} run without --dry-run to install\n"
