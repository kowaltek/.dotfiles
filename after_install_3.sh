#!/bin/zsh

set -e

# install typescript globally (needed by pop shell install)
npm install -g typescript

# workspaces mod
./gnome_workspaces_mod.sh

# install yarn - needed for some neovim plugins
npm install --global yarn

# install neovim plugins
# error output needs to redirected as there are plenty errors
# after running neovim's config without plugins installed
nvim --headless +PackerSync +qa &>/dev/null

sh ./font_install.sh

printf "\n\nRemember to set your font to Hack Nerd Font in terminal emulator.\n\n	You need to login again\n\n"
