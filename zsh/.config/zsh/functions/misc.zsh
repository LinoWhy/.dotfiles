# Run command on each remote host concurrently using parallel
function ssh-run() {
  local OPTIND opt ssh_user timeout
  while getopts ":u:t:" opt; do
    case "$opt" in
      u) ssh_user="$OPTARG" ;;
      t) timeout="$OPTARG" ;;
      *) echo "Usage: ssh-run [-u user] [-t timeout] <command>"; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  local command="$*"

  if [[ -z "$command" ]]; then
    echo "Usage: ssh-run [-u user] [-t timeout] <command>"
    return 1
  fi

  local hosts
  if [[ -n "$ssh_user" ]]; then
    hosts=$(awk -v user="$ssh_user" '
      tolower($1) == "host" { host = $2 }
      tolower($1) == "user" && $2 == user && host !~ /[*?]/ {
        print host
      }
    ' ~/.ssh/config)
  else
    hosts=$(rg '^Host ' ~/.ssh/config | awk '{print $2}')
  fi

  local -a parallel_options=(-j0 --keep-order)
  [[ -n "$timeout" ]] && parallel_options+=(--timeout "$timeout")

  local job='ssh -n {} "'"$command"'" 2>&1 | awk "NF {if(!header) {print \"\"; print \"\033[1;34m{}\033[0m\"; header=1} print}"'
  local timeout_marker="__SSH_RUN_TIMEOUT__:"
  if [[ -n "$timeout" ]]; then
    job="trap 'printf \"${timeout_marker}%s\\n\" \"{}\"' TERM; $job"
  fi

  echo "$hosts" | parallel "${parallel_options[@]}" "$job" 2>/dev/null | awk -v marker="$timeout_marker" '
    index($0, marker) == 1 {
      timeouts[++timeout_count] = substr($0, length(marker) + 1)
      next
    }
    { print }
    END {
      if (timeout_count) {
        print ""
        for (i = 1; i <= timeout_count; i++) {
          printf "\033[1;31m%s timeout\033[0m\n", timeouts[i]
        }
      }
    }
  '
  local parallel_status=$pipestatus[2]
  return $parallel_status
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
  ' ~/.ssh/config | sort | fzf --prompt=" SSH Host > " --exit-0 --no-preview)

  if [[ -n $ssh_host ]]; then
    ssh "$ssh_host" $@
  fi
}

# Setup configuration directory in ~/.config/nvim-<config> manually
function nvs() {
  fd -td -tl -d1 'nvim' ~/.config -x basename | sort | \
    fzf --prompt=" Neovim Config > " --bind "enter:become(NVIM_APPNAME={} nvim $@)"
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

function rm_color() {
  sed 's/\x1b\[[0-9;]*m//g'
}
