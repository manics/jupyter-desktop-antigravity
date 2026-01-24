#!/bin/sh
set -eu

MACHINE=$(uname -m)

curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
    gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > \
    /etc/apt/sources.list.d/antigravity.list


apt-get update -y -q
apt-get install -y -q --no-install-recommends \
    antigravity \
    bash-completion \
    build-essential \
    git \
    gnome-keyring \
    openssh-client

# Google Chrome isn't available for linux/arm64
if [ "$MACHINE" = x86_64 ]; then
    curl -fsSO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt-get install -y -q --no-install-recommends ./google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
else
    apt-get install -y -q --no-install-recommends chromium-browser
fi

apt-get remove -y -q mate-power-manager
apt-get autoremove -y -q
