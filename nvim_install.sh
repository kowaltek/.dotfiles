#!/bin/bash

set -e

wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage

mv nvim-linux-x86_64.appimage ~/Applications/nvim
chmod +x ~/Applications/nvim
rm -rf shasum.txt
