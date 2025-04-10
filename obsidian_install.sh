#!/bin/bash

set -e

wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.9/obsidian_1.8.9_amd64.deb
sudo apt-get -y install ./obsidian_1.8.9_amd64.deb
rm -rf obsidian_1.8.9_amd64.deb

