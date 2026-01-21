#!/usr/bin/env bash

SESSION_NAME="update_env"

if ! command -v tmux &>/dev/null; then
  echo "tmux is not installed. Please install tmux and try again."
  exit 1
fi

if tmux has-session -t $SESSION_NAME >/dev/null 2>&1; then
  tmux kill-session -t $SESSION_NAME
  sleep 2
fi
tmux new-session -d -s $SESSION_NAME

# zsh
tmux send-keys "zap update all" Enter
tmux send-keys "exit" Enter

# fzf
tmux split-window
tmux send-keys "cd ~/.fzf && git pull && ./install && exit" Enter
tmux send-keys "y" Enter
tmux send-keys "y" Enter
tmux send-keys "n" Enter

# package
tmux split-window
tmux send-keys "sudo apt-get update && sudo apt-get upgrade -y && exit" Enter

# NEW WINDOW
tmux select-layout tiled
tmux new-window -t "$SESSION_NAME"

# nvim
tmux send-keys 'nv --headless "+Lazy! sync" +TSUpdateSync +qa && exit' Enter

if [ -f ~/.cargo/bin/rustup ]; then
  tmux split-window
  tmux send-keys "rustup update" Enter
  tmux send-keys "cargo install-update -a" Enter
  tmux send-keys "exit" Enter
fi

# neovim
if [ -d ~/personal/neovim ]; then
  tmux split-window
  tmux send-keys "cd ~/personal/neovim && git checkout release-0.11 && git pull" Enter
  tmux send-keys "make CMAKE_BUILD_TYPE=Release" Enter
  tmux send-keys "cd build && cpack -G DEB && sudo dpkg -i nvim-linux-x86_64.deb && exit" Enter
fi

tmux select-layout tiled
tmux select-window -t 1
tmux attach-session -t $SESSION_NAME
