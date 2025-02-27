#!/usr/bin/env bash
# Install all the tools line by line!!!

# GH_SITE="https://mirror.ghproxy.com/https://github.com"
GH_SITE="https://github.com"

# Install neovim & other cli tools
mkdir -p ~/self && mkdir -p ~/.local/bin && cd ~/self &&
  wget ${GH_SITE}/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz &&
  tar xzf nvim-linux-x86_64.tar.gz && ln -sf ~/self/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim &&
  rm nvim-linux-x86_64.tar.gz &&
  # wget ${GH_SITE}/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_amd64.deb &&
  # sudo dpkg -i duf_0.8.1_linux_amd64.deb &&
  # rm duf_0.8.1_linux_amd64.deb &&
  wget ${GH_SITE}/LinoWhy/cli-tools/releases/latest/download/rust_cli_tools.tar.gz &&
  tar xzf rust_cli_tools.tar.gz -C ~/.local/bin &&
  rm rust_cli_tools.tar.gz

# Clone dotfiles, fzf & tmux
git clone https://github.com/LinoWhy/.dotfiles.git ~/.dotfiles &&
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install &&
  git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm

# Install stow without root
cd ~/self && wget http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz && tar -xvf stow-latest.tar.gz &&
  cd $(ls -Avr | grep -m1 -axEe 'stow-[0-9.]+') &&
  ./configure --prefix="$HOME"/.local/stow && make && make install &&
  ln -s ~/.local/stow/bin/stow ~/.local/bin/stow
STOW=~/.local/bin/stow

# Setup configurations
cd ~/self && wget https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh &&
  touch ~/.zshrc && zsh install.zsh --branch release-v1 -k &&
  rm install.zsh &&
  mv ~/.bashrc ~/.bashrc.bak && cd ~/.dotfiles && ${STOW:-stow} -v */

chsh -s $(which zsh)

# NOTE: personal neovim config might be too aggressive!
rm -rf ~/.config/nvim

# Upgrade tmux to support copy/paste in neovim
# WITH SUDO PRIVILEGE
# manual install need libevent, ncurses and bison
mkdir -p ~/self/tmux; cd ~/self/tmux &&
  wget https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz &&
  tar xzvf tmux-3.5a.tar.gz && cd tmux-3.5a && ./configure && make -j8 && sudo make install

# Ending
zsh
bat cache --build
tldr -u
