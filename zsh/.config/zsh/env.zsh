function isWsl {
  if [[ "$(</proc/sys/kernel/osrelease)" == *microsoft* ]]; then
    return 0
  fi
  return 1
}

if isWsl; then
  alias start='wslview'
fi

## add following lines to /mnt/c/Users/<useranme>/.wslconfig
# [experimental]
# autoMemoryReclaim=gradual
# networkingMode=mirrored
# dnsTunneling=true
# firewall=true
# autoProxy=true
