# Run command on each remote host concurrently using parallel
function ssh-run() {
  local command="$*"

  if [[ -z "$command" ]]; then
    echo "Usage: ssh-run <command>"
    return 1
  fi

  local hosts=$(rg '^Host ' ~/.ssh/config | awk '{print $2}')
  echo "$hosts" | parallel -j0 --keep-order \
    'ssh -n {} "'"$command"'" 2>&1 | awk "NF {if(!header) {print \"\"; print \"\033[1;34m{}\033[0m\"; header=1} print}"'
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
