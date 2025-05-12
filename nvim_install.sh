#!/bin/bash

set -e

wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
wget https://github.com/neovim/neovim/releases/download/stable/shasum.txt
sha256sum nvim-linux-x86_64.appimage

if [[ "$(sha256sum -c --ignore-missing shasum.txt)" != "nvim-linux-x86_64.appimage: OK" ]];
then
    rm -rf nvim-linux-x86_64.appimage shasum.txt
    printf "\n\n    Checksum for neovim not matching - exiting!\n\n"
    exit 1
fi

mv nvim-linux-x86_64.appimage ~/Applications/nvim
chmod +x ~/Applications/nvim
rm -rf shasum.txt
