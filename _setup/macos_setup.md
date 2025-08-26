# macOS Setup

## Bootstrap

```sh
xcode-select --install

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_INSTALL_FROM_API=1

export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

/bin/bash -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"

brew install stow
cd ~/.dotfiles && stow -v -t ~ homebrew/
brew bundle --global

mkdir -p ~/self && git clone git@github.com:LinoWhy/Recursive-Fonts.git
cd Recursive-Fonts && cp -r fonts/ ~/Library/Fonts/
fc-cache -fv

mkdir -p ~/.config
stow -nv -t ~ */

echo "export PLUGIN_IN_NEOVIM=1" >> ~/.envrc
echo "export AI_IN_NEOVIM=1" >> ~/.envrc
direnv allow ~

bat cache --build
tldr -u
```

## Other software

- flameshot
- nomachine
