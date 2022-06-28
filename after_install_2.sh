#!/bin/bash

# make zsh default
chsh -s $(which zsh)

# install nvm and node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install --lts

# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install yarn - needed for some neovim plugins
npm install --global yarn

# stow configs
rm ~/.zshrc
cd ~/.dotfiles
stow nvim tmux zsh alacritty

# install ohmyzsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install vim-plugged
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install neovim plugins
nvim --headless +PlugInstall +qall

echo '\r\r	You need to reopen you terminal\r\r'
