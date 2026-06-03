#!/bin/sh
set -eu

MACHINE=$(uname -m)

apt-get update -y -q
apt-get install -y -q --no-install-recommends \
    bash-completion \
    build-essential \
    git \
    gnome-keyring \
    openssh-client

# Google Chrome isn't available for linux/arm64
if [ "$MACHINE" = x86_64 ]; then
    echo Installing Google Chrome
    curl -fsSO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt-get install -y -q --no-install-recommends ./google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
else
    echo Installing Chromium
    apt-get install -y -q --no-install-recommends chromium-browser
fi

apt-get remove -y -q mate-power-manager
apt-get autoremove -y -q
