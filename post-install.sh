#!/usr/bin/env bash
set -euxo pipefail

# Clean up data from old implementation
rm -rf ~/.vortex-linux/proton-builds/
rm -rf ~/home/deck/Vortex/Vortex/vortex-linux

echo "Templating files..."
pushd ~/.IArentBen/steam-deck-master/
find . -type f -name "*.in" -exec sh -c 'envsubst < "$1" > "${1%.in}" && chmod +x "${1%.in}"' _ {} \;
popd

ln -sf ~/.IArentBen/steam-deck-master/update.desktop ~/Desktop/IArentBen-update.desktop

if [ ! -f "$HOME/.local/share/applications/vortex.desktop" ]; then
    echo "Creating Vortex install desktop shortcut..."
    ln -s ~/home/deck/Vortex/Vortex/install-vortex.desktop ~/Desktop/install-vortex.desktop || true
else
    # update .desktop file to make sure it's up to date
    cp ~/home/deck/Vortex/Vortex/vortex.desktop ~/.local/share/applications/

    echo "Creating Vortex desktop shortcuts..."
    ln -sf ~/.local/share/applications/vortex.desktop ~/Desktop/
    ln -sf ~/home/deck/Vortex/Vortex/skyrim-post-deploy.desktop ~/Desktop/
    ln -sf ~/home/deck/Vortex/Vortex/skyrimle-post-deploy.desktop ~/Desktop/
    ln -sf ~/home/deck/Vortex/Vortex/fallout4-post-deploy.desktop ~/Desktop/
    ln -sf ~/home/deck/Vortex/Vortex/falloutnv-post-deploy.desktop ~/Desktop/
    ln -sf ~/home/deck/Vortex/Vortex/fallout3-post-deploy.desktop ~/Desktop/
    ln -sf ~/home/deck/Vortex/Vortex/oblivion-post-deploy.desktop ~/Desktop/

    echo "Vortex is already installed, updating umu-launcher..."
    ~/home/deck/Vortex/Vortex/install-umu.sh
fi

MOUNTPOINT="$(findmnt /dev/mmcblk0p1 -o TARGET -n)"

mkdir -p $MOUNTPOINT/vortex-downloads || true
