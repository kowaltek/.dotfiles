#!/bin/zsh

set -e

# install golangci-lint
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.5.0

# install typescript globally (needed by pop shell install)
vp install -g typescript

# workspaces mod
./gnome_workspaces_mod.sh

# install yarn - needed for some neovim plugins
vp install -g yarn

sh ./font_install.sh

printf "\n\nRemember to set your font to Hack Nerd Font in terminal emulator.\n\n	You need to login again\n\n"
