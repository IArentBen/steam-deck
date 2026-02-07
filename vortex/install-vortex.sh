#!/usr/bin/env bash
set -euxo pipefail

VORTEX_VERSION="1.16.0-beta.5"
VORTEX_INSTALLER="vortex-setup-$VORTEX_VERSION.exe"
VORTEX_URL="https://github.com/Nexus-Mods/Vortex/releases/download/v$VORTEX_VERSION/$VORTEX_INSTALLER"
DOTNET_URL="https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/6.0.36/windowsdesktop-runtime-6.0.36-win-x64.exe"

export WINEPREFIX="$HOME/.vortex-linux/compatdata/pfx"

mkdir -p ~/home/deck/Vortex/Vortex/
cd ~/home/deck/Vortex/Vortex/

# Install umu-launcher
./install-umu.sh

# Download Vortex installer
wget -O "$VORTEX_INSTALLER" "$VORTEX_URL"

# Install .NET runtime
wget -O dotnet-runtime.exe "$DOTNET_URL"
~/Vortex/umu/umu-run dotnet-runtime.exe /q

# Install Vortex
~/Vortex/umu/umu-run "$VORTEX_INSTALLER" /S

# Create desktop file
mkdir -p ~/.local/share/applications
cp ~/home/deck/Vortex/Vortex/vortex.desktop ~/.local/share/applications/

# Set up drive letter mappings for Steam libraries
cd "$WINEPREFIX/dosdevices"

if [ -d "$HOME/.steam/steam/steamapps/common/" ]; then
    ln -s "$HOME/.steam/steam/steamapps/common/" j: || true
fi

MOUNTPOINT="$(findmnt /dev/mmcblk0p1 -o TARGET -n)"
if [ -d "$MOUNTPOINT/steamapps/common/" ]; then
    ln -s "$MOUNTPOINT/steamapps/common/" k: || true
fi

update-desktop-database || true

rm -f ~/Desktop/install-vortex.desktop
ln -sf ~/.local/share/applications/vortex.desktop ~/Desktop/
ln -sf ~/home/deck/Vortex/Vortex/skyrim-post-deploy.desktop ~/Desktop/
ln -sf ~/home/deck/Vortex/Vortex/skyrimle-post-deploy.desktop ~/Desktop/
ln -sf ~/home/deck/Vortex/Vortex/fallout4-post-deploy.desktop ~/Desktop/
ln -sf ~/home/deck/Vortex/Vortex/falloutnv-post-deploy.desktop ~/Desktop/
ln -sf ~/home/deck/Vortex/Vortex/falloutnv-pre-deploy.desktop ~/Desktop/
ln -sf ~/home/deck/Vortex/Vortex/fallout3-post-deploy.desktop ~/Desktop/
ln -sf ~/home/deck/Vortex/Vortex/oblivion-post-deploy.desktop ~/Desktop/

mkdir -p $MOUNTPOINT/vortex-downloads || true

echo "Success! Exiting in 3..."
sleep 3
