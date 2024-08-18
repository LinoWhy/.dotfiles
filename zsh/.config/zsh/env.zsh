function isWsl {
  if [[ "$(</proc/sys/kernel/osrelease)" == *microsoft* ]]; then
    return 0
  fi
  return 1
}

if isWsl; then
  alias start='wslview'
fi

# add proxy
# set "nameserver 8.8.8.8" in /etc/resolv.conf?
if isWsl; then
  export hostip=$(ip route | grep default | awk '{print $3}')
  export socks_hostport=10810 # v2ray
  export http_hostport=10811 #v2ray
  alias proxy='
    export https_proxy="http://${hostip}:${http_hostport}"
    export http_proxy="http://${hostip}:${http_hostport}"
    export ALL_PROXY="socks5://${hostip}:${socks_hostport}"
    export all_proxy="socks5://${hostip}:${socks_hostport}"
  '
  alias unproxy='
    unset ALL_PROXY
    unset https_proxy
    unset http_proxy
    unset all_proxy
  '
  alias echoproxy='
    echo $ALL_PROXY
    echo $all_proxy
    echo $https_proxy
    echo $http_proxy
  '
fi
