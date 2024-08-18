#!/usr/bin/env bash

# exit if not a file or directory
[ ! -e "$1" ] && exit 0

file_mime=$(file --dereference --mime "$1")

# list directory
[[ "${file_mime}" =~ directory ]] &&
  lsd --tree --depth 1 --color always "$1" &&
  exit 0

# display text file content
[[ "${file_mime}" =~ text || "${file_mime}" =~ json ]] &&
  bat --style=numbers --color=always --line-range :500 "$1" &&
  exit 0

# display file info
file --dereference --brief "$1" &&
  exit 0
