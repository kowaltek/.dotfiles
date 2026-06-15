#!/bin/bash

set -e

# install needed node packages
vp install -g sql-formatter

# install govm
go install github.com/melkeydev/govm@latest

# install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# stow configs
rm ~/.zshrc || true
cd ~/.dotfiles
stow nvim tmux zsh i3 i3status alacritty psql kanata

systemctl --user daemon-reload
systemctl --user enable --now kanata.service

printf "\n\n	You need to login again\n\n"
