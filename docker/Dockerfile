FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ARG USER=docker

# Set timezone
ENV TIME_ZONE="Asia/Shanghai"
RUN echo ${TIME_ZONE} > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# Replace apt source
RUN sed -i 's@archive.ubuntu.com@mirrors.aliyun.com@g; \
    s@security.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list && \
    apt-get update

# Create a user with sudo privilege
RUN apt-get install -y sudo && \
    adduser --disabled-password --gecos '' ${USER} && \
    adduser ${USER} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch user
USER ${USER}
WORKDIR /home/${USER}

# Install essential packages
RUN sudo apt-get update && sudo apt-get install -y zsh pip python-is-python3 python3-venv \
    curl wget git make cmake stow xclip tmux unzip iproute2 software-properties-common \
    openssh-client openssh-server libssl-dev
    # duf not on ubuntu 20.04

# Install neovim & other cli tools
ARG GH_SITE="https://mirror.ghproxy.com/https://github.com"
RUN mkdir -p ~/self && mkdir -p ~/.local/bin && cd ~/self && \
    wget ${GH_SITE}/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar xzf nvim-linux64.tar.gz && ln -s ~/self/nvim-linux64/bin/nvim ~/.local/bin/nvim && \
    rm nvim-linux64.tar.gz && cd - && \
    wget ${GH_SITE}/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_amd64.deb && \
    sudo dpkg -i duf_0.8.1_linux_amd64.deb && \
    rm duf_0.8.1_linux_amd64.deb && \
    wget ${GH_SITE}/LinoWhy/cli-tools/releases/latest/download/rust_cli_tools.tar.gz && \
    tar xzf rust_cli_tools.tar.gz -C ~/.local/bin && \
    rm rust_cli_tools.tar.gz

# Clone dotfiles, fzf & tmux
RUN git clone https://github.com/LinoWhy/.dotfiles.git && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install && \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Setup configurations
RUN wget https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh && \
    zsh install.zsh --branch release-v1 -k && \
    rm install.zsh && \
    mv ~/.bashrc ~/.bashrc.bak && cd ~/.dotfiles && stow */ && \
    sudo chsh -s $(which zsh)
