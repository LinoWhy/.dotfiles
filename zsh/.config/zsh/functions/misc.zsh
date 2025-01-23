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
