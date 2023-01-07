#!/bin/bash

# installs hack nerd font and patches it

sudo add-apt-repository ppa:fontforge/fontforge
sudo apt update
sudo apt install fontforge

git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cp nerd-fonts/src/glyphs/codicons/codicon.ttf nerd-fonts/src/glyphs
fontforge -script nerd-fonts/font-patcher nerd-fonts/src/unpatched-fonts/Hack/Regular/Hack-Regular.ttf -s -c

cp Hack* ~/.local/share/fonts

rm -rf nerd-fonts
rm -rf Hack*
