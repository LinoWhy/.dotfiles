function set_win_title() {
  echo -ne "\033]0;$(basename "$PWD")\007"
}

# clone config in ~/.config/nvim-$config manually
function nvs() {
  items=("default" "lazy" "kickstart" "mini")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config > " --height=~50% --layout=reverse --border --exit-0 --no-preview)
  if [[ -z $config ]]; then
    return 0
  elif [[ $config == "default" ]]; then
    nvim $@
  else
    NVIM_APPNAME="nvim-$config" nvim $@
  fi
}

# push to current tracking remote branch on gerrit
function ggp() {
  remote_name=$(git remote)
  branch_name=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} | awk -F'/' '{print substr($0, index($0,$2))}')

  yellow='\033[1;33m'
  reset='\033[0m'

  # Check if branch name is non-empty
  if [[ -n "$branch_name" ]]; then
    echo "${yellow}pushing to $remote_name $branch_name${reset}"
    git push $remote_name HEAD:refs/for/$branch_name
  else
    echo "Error: Cannot determine the remote branch to push."
  fi
}

# detect lfs repo and pull under $1 or $PWD
function gplfs() {
  local directory="${1:-$PWD}"
  rg -l -F "merge=lfs" --glob=".gitattributes" | while IFS= read -r line; do
    local dir=$(dirname "$line")
    echo "git lfs pull for \"$dir\""
    (cd "$dir" || exit ; git lfs pull)
  done
}

# shallow fetch a remote branch, works within a shallow gloned repo
function gsf() {
  git fetch --depth=1 origin "$1:$1"
  git switch "$1"
}

# change the current working directory when exiting Yazi
function ya() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  echo "$tmp"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function mdcd() {
  mkdir -p "$1" && cd "$1" || return 1
}

# Select a docker image to run interactively & attach to
function drun() {
  image=$(docker image ls | tail -n +2 | fzf | sed -n 's/\(\S*\) *\(\S*\).*/\1:\2/p')
  [ -n  "$image" ] && docker run -dit $image $@ && docker attach $(docker ps -lq)

}

# Select a docker container to start and attach to
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a docker container to remove
function drm() {
  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
}

# Select a docker image or images to remove
function drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
}

# Refresh tmux related environment, used for a session shared with local & remote machine
function renv() {
  eval $(tmux show-env -s)
}

function gen_editorconfig() {
  local clang_format_file="${1:-.clang-format}"
  local clang_format_output=$(clang-format --style=file:"$clang_format_file" --dump-config | rg "^ColumnLimit|^IndentWidth|^TabWidth|^UseTab")
  local editorconfig_content=$(echo "$clang_format_output" | awk '
    BEGIN {
      print("[*.{c,cc,cpp,h}]")
    }
    /ColumnLimit:/ {
      printf("max_line_length = %d\n", $2)
    }
    /IndentWidth:/ {
      printf("indent_size = %d\n", $2)
    }
    /TabWidth:/ {
      printf("tab_width = %d\n", $2)
    }
    /UseTab:/ {
      if ($2 == "Never") {
        print("indent_style = space")
      } else if ($2 == "Always") {
        print("indent_style = tab")
      }
    }
  ')
  echo "$editorconfig_content"
}
