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
  "com.apple.WindowManager:com.apple.WindowManager.plist"
  "com.apple.AppleMultitouchTrackpad:com.apple.AppleMultitouchTrackpad.plist"
  "com.apple.driver.AppleBluetoothMultitouch.trackpad:com.apple.driver.AppleBluetoothMultitouch.trackpad.plist"
  "com.apple.AppleMultitouchMouse:com.apple.AppleMultitouchMouse.plist"
  "com.apple.driver.AppleBluetoothMultitouch.mouse:com.apple.driver.AppleBluetoothMultitouch.mouse.plist"
  "com.apple.menuextra.clock:com.apple.menuextra.clock.plist"
  "com.apple.menuextra.textinput:com.apple.menuextra.textinput.plist"
  "com.apple.keyboard.preferences:com.apple.keyboard.preferences.plist"
)

typeset -ar SELECTED_DOMAINS=(
  "com.apple.HIToolbox"
  "com.apple.spaces"
)

usage() {
  print -u2 "Usage: ${0:t} <backup|restore>"
}

backup_selected_preferences() {
  local source_path backup_path temporary_path value

  source_path="${USER_PREFERENCES_DIR}/com.apple.HIToolbox.plist"
  backup_path="${BACKUP_DIR}/com.apple.HIToolbox.plist"
  temporary_path="$(mktemp "${BACKUP_DIR}/.com.apple.HIToolbox.plist.XXXXXX")"
  plutil -create xml1 "${temporary_path}"
  value="$(plutil -extract AppleFnUsageType raw -o - "${source_path}")"
  plutil -insert AppleFnUsageType -integer "${value}" "${temporary_path}"
  plutil -insert AppleGlobalTextInputProperties -dictionary "${temporary_path}"
  value="$(plutil -extract AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput raw -o - "${source_path}")"
  plutil -insert AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput -bool "${value}" "${temporary_path}"
  mv -f "${temporary_path}" "${backup_path}"
  print "backup  com.apple.HIToolbox (selected keys)"

  source_path="${USER_PREFERENCES_DIR}/com.apple.spaces.plist"
  backup_path="${BACKUP_DIR}/com.apple.spaces.plist"
  temporary_path="$(mktemp "${BACKUP_DIR}/.com.apple.spaces.plist.XXXXXX")"
  plutil -create xml1 "${temporary_path}"
  value="$(plutil -extract spans-displays raw -o - "${source_path}")"
  plutil -insert spans-displays -bool "${value}" "${temporary_path}"
  mv -f "${temporary_path}" "${backup_path}"
  print "backup  com.apple.spaces (selected keys)"
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

  backup_selected_preferences
  (( saved += ${#SELECTED_DOMAINS[@]} ))

  print
  print "Saved ${saved} preference domains to ${BACKUP_DIR} (${skipped} skipped)."
  print "Review the XML plist changes before committing them."
}

restore_preferences() {
  if [[ ! -d "${BACKUP_DIR}" ]]; then
    print -u2 "error: backup directory does not exist: ${BACKUP_DIR}"
    return 1
  fi

  local spec domain backup_path answer process value
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
  for domain in "${SELECTED_DOMAINS[@]}"; do
    backup_path="${BACKUP_DIR}/${domain}.plist"
    if [[ -f "${backup_path}" ]]; then
      print "  ${domain} (selected keys)"
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

  backup_path="${BACKUP_DIR}/com.apple.HIToolbox.plist"
  if [[ -f "${backup_path}" ]]; then
    value="$(plutil -extract AppleFnUsageType raw -o - "${backup_path}")"
    defaults write com.apple.HIToolbox AppleFnUsageType -int "${value}"
    value="$(plutil -extract AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput raw -o - "${backup_path}")"
    defaults write com.apple.HIToolbox AppleGlobalTextInputProperties -dict-add TextInputGlobalPropertyPerContextInput -bool "${value}"
    print "restore com.apple.HIToolbox (selected keys)"
    (( restored += 1 ))
  fi

  backup_path="${BACKUP_DIR}/com.apple.spaces.plist"
  if [[ -f "${backup_path}" ]]; then
    value="$(plutil -extract spans-displays raw -o - "${backup_path}")"
    defaults write com.apple.spaces spans-displays -bool "${value}"
    print "restore com.apple.spaces (selected keys)"
    (( restored += 1 ))
  fi

  # Restart only processes owned by the current user. No sudo is used.
  for process in cfprefsd Dock Finder SystemUIServer; do
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
