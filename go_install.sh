#!/bin/bash

set -e

wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz
rm -rf sudo /usr/local/go && sudo tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz
rm go1.24.2.linux-amd64.tar.gz
