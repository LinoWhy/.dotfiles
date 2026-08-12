#!/bin/zsh

set -euo pipefail

readonly SCRIPT_DIR="${0:A:h}"
readonly BACKUP_DIR="${SCRIPT_DIR}/preferences"
readonly USER_PREFERENCES_DIR="${HOME}/Library/Preferences"

# Each entry is "defaults-domain:plist-file-in-~/Library/Preferences".
# This is intentionally a domain allowlist: it excludes third-party app
# preferences, wallpaper state, managed preferences, and ByHost settings.
typeset -ar PREFERENCE_SPECS=(
  "NSGlobalDomain:.GlobalPreferences.plist"
  "com.apple.symbolichotkeys:com.apple.symbolichotkeys.plist"
  "com.apple.dock:com.apple.dock.plist"
  "com.apple.finder:com.apple.finder.plist"
  "com.apple.controlcenter:com.apple.controlcenter.plist"
  "com.apple.spaces:com.apple.spaces.plist"
  "com.apple.WindowManager:com.apple.WindowManager.plist"
  "com.apple.screencapture:com.apple.screencapture.plist"
  "com.apple.HIToolbox:com.apple.HIToolbox.plist"
  "com.apple.AppleMultitouchTrackpad:com.apple.AppleMultitouchTrackpad.plist"
  "com.apple.driver.AppleBluetoothMultitouch.trackpad:com.apple.driver.AppleBluetoothMultitouch.trackpad.plist"
  "com.apple.AppleMultitouchMouse:com.apple.AppleMultitouchMouse.plist"
  "com.apple.driver.AppleBluetoothMultitouch.mouse:com.apple.driver.AppleBluetoothMultitouch.mouse.plist"
  "com.apple.menuextra.clock:com.apple.menuextra.clock.plist"
  "com.apple.menuextra.textinput:com.apple.menuextra.textinput.plist"
  "com.apple.keyboard.preferences:com.apple.keyboard.preferences.plist"
)

usage() {
  print -u2 "Usage: ${0:t} <backup|restore>"
}

backup_preferences() {
  mkdir -p "${BACKUP_DIR}"

  local spec domain source_name source_path backup_path temporary_path
  local saved=0
  local skipped=0

  for spec in "${PREFERENCE_SPECS[@]}"; do
    domain="${spec%%:*}"
    source_name="${spec#*:}"
    source_path="${USER_PREFERENCES_DIR}/${source_name}"
    backup_path="${BACKUP_DIR}/${domain}.plist"

    if [[ ! -f "${source_path}" ]]; then
      # Do not retain an obsolete backup when the domain no longer exists.
      rm -f "${backup_path}"
      print "skip    ${domain} (not found)"
      (( skipped += 1 ))
      continue
    fi

    if ! plutil -lint "${source_path}" >/dev/null; then
      print -u2 "error: invalid plist: ${source_path}"
      return 1
    fi

    temporary_path="$(mktemp "${BACKUP_DIR}/.${domain}.plist.XXXXXX")"
    if ! plutil -convert xml1 -o "${temporary_path}" "${source_path}"; then
      rm -f "${temporary_path}"
      return 1
    fi
    mv -f "${temporary_path}" "${backup_path}"
    print "backup  ${domain}"
    (( saved += 1 ))
  done

  print
  print "Saved ${saved} preference domains to ${BACKUP_DIR} (${skipped} skipped)."
  print "Review the XML plist changes before committing them."
}

restore_preferences() {
  if [[ ! -d "${BACKUP_DIR}" ]]; then
    print -u2 "error: backup directory does not exist: ${BACKUP_DIR}"
    return 1
  fi

  local spec domain backup_path answer process
  local available=0
  local restored=0

  print "The following preference domains are available for restore:"
  for spec in "${PREFERENCE_SPECS[@]}"; do
    domain="${spec%%:*}"
    backup_path="${BACKUP_DIR}/${domain}.plist"
    if [[ -f "${backup_path}" ]]; then
      print "  ${domain}"
      (( available += 1 ))
    fi
  done

  if (( available == 0 )); then
    print -u2 "error: no allowlisted preference backups found"
    return 1
  fi

  print
  read "answer?Restore ${available} domains into this user account? [y/N] "
  if [[ "${answer:l}" != "y" && "${answer:l}" != "yes" ]]; then
    print "Restore cancelled."
    return 0
  fi

  for spec in "${PREFERENCE_SPECS[@]}"; do
    domain="${spec%%:*}"
    backup_path="${BACKUP_DIR}/${domain}.plist"
    [[ -f "${backup_path}" ]] || continue

    if ! plutil -lint "${backup_path}" >/dev/null; then
      print -u2 "error: invalid backup plist: ${backup_path}"
      return 1
    fi

    defaults import "${domain}" "${backup_path}"
    print "restore ${domain}"
    (( restored += 1 ))
  done

  # Restart only processes owned by the current user. No sudo is used.
  for process in cfprefsd Dock Finder ControlCenter SystemUIServer; do
    killall "${process}" >/dev/null 2>&1 || true
  done

  print
  print "Restored ${restored} preference domains."
  print "Log out and back in if a keyboard or menu bar setting has not refreshed."
}

case "${1:-}" in
  backup)
    backup_preferences
    ;;
  restore)
    restore_preferences
    ;;
  *)
    usage
    exit 2
    ;;
esac
