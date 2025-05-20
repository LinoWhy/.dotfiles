# Run command on each remote host
function ssh-run() {
  local command="$*"

  if [[ -z "$command" ]]; then
    echo "Usage: ssh-run <command>"
    return 1
  fi

  local hosts=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}')
  while read -r host; do
    echo -e "\n\e[1;31m$host\e[0m: \e[1;32m$command\e[0m"
    ssh -n "$host" "$command"
  done <<< "$hosts"
}

# Select SSH host from ~/.ssh/config using fzf
function sshs() {
  local ssh_host=$(awk '
    /^Host / {
      for (i=2; i<=NF; i++) {
        if ($i !~ /[*?]/) {
          print $i
        }
      }
    }
  ' ~/.ssh/config | sort | fzf --prompt=" SSH Host > " --height=~50% --layout=reverse --border --exit-0 --no-preview)

  if [[ -n $ssh_host ]]; then
    ssh "$ssh_host" $@
  fi
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

# Select a tmux session and change or attach to
function tt() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux $change -t "$session"
}

function mdcd() {
  mkdir -p "$1" && cd "$1" || return 1
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

function bell() {
  echo -n -e '\a'
}
