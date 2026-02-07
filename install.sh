#!/usr/bin/env bash
set -euxo pipefail

mkdir -p ~/.local/share/applications/

mkdir -p ~/Vortex
cd ~/Vortex/
wget -O steam-deck.zip https://github.com/IArentBen/steam-deck/archive/refs/heads/master.zip
unzip -o steam-deck.zip
rm steam-deck.zip

~/Vortex/steam-deck-master/post-install.sh

echo "Success! Exiting in 3..."
sleep 3
