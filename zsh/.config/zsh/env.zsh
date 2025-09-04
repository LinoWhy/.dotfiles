function ostype {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -q microsoft /proc/version 2>/dev/null; then
      echo "wsl"
    else
      echo "linux"
    fi
  elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "windows"
  else
    echo "unknown"
  fi
}

if [[ $(ostype) == "wsl" ]]; then
  alias start='wslview'
fi

## add following lines to /mnt/c/Users/<useranme>/.wslconfig
# [experimental]
# autoMemoryReclaim=gradual
# networkingMode=mirrored
# dnsTunneling=true
# firewall=true
# autoProxy=true
