FROM ubuntu:20.04

ARG GROUP=docker
ARG USER=docker
ARG UID=1000
ARG GID=1000
ARG GH_SITE="https://github.com"
# ARG GH_SITE="https://mirror.ghproxy.com/https://github.com"

# Set timezone
ENV TIME_ZONE="Asia/Shanghai"
RUN echo ${TIME_ZONE} > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# Replace apt source
RUN sed -i 's@archive.ubuntu.com@mirrors.aliyun.com@g; \
    s@security.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list && \
    apt-get update

# Create a group with the specified group id
RUN groupadd -g ${GID} ${GROUP}

# Create a user with sudo privilege
RUN apt-get install -y stow zsh sudo && \
    adduser --home /home/${USER} --uid ${UID} --gid ${GID} \
    --shell $(which zsh) --disabled-password --gecos '' ${USER} && \
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
RUN mkdir -p ~/personal && mkdir -p ~/.local/bin && cd ~/personal && \
    wget ${GH_SITE}/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz && \
    tar xzf nvim-linux-x86_64.tar.gz && ln -sf ~/personal/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz && \
    wget ${GH_SITE}/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_amd64.deb && \
    sudo dpkg -i duf_0.8.1_linux_amd64.deb && \
    rm duf_0.8.1_linux_amd64.deb && \
    curl -sfL https://direnv.net/install.sh | sudo bash && \
    wget ${GH_SITE}/LinoWhy/cli-tools/releases/latest/download/rust_cli_tools.tar.gz && \
    tar xzf rust_cli_tools.tar.gz -C ~/.local/bin && \
    rm rust_cli_tools.tar.gz

# Clone dotfiles, fzf & tmux
RUN git clone https://github.com/LinoWhy/.dotfiles.git ~/.dotfiles && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all && \
    git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm

# Install tmux manually
RUN sudo apt install -y libevent-dev libncurses-dev libbison-dev && \
    mkdir -p ~/personal/tmux; cd ~/personal/tmux && \
    wget https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz && \
    tar xzvf tmux-3.5a.tar.gz && cd tmux-3.5a && ./configure && make -j8 && sudo make install

# zsh & setup environment
RUN cd ~/personal && wget https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh && \
    touch ~/.zshrc && zsh install.zsh --branch release-v1 -k && \
    rm install.zsh && \
    mv ~/.bashrc ~/.bashrc.bak && cd ~/.dotfiles && ${STOW:-stow} -v */

RUN ~/.local/share/tmux/plugins/tpm/bin/install_plugins
RUN ~/.local/bin/bat cache --build
RUN ~/.local/bin/tldr -u

ENTRYPOINT ["zsh"]

# docker build --build-arg GROUP=$(id -gn) --build-arg USER=$(id -un) --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t XXXX .
# docker run -dit --name XXXX --hostname YYYY
