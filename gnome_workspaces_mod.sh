#!/bin/bash

# set default terminal emulator to alacritty
gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'

# unbind from ubuntu dock
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false

gsettings set org.gnome.mutter dynamic-workspaces false 

gsettings set org.gnome.desktop.wm.preferences num-workspaces 8

for i in {1..9}; do gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]";done

for i in {1..9}; do gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']";done

for i in {1..9}; do gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']";done
