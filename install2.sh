#!/bin/sh
# https://antigravity.google/download
set -eu

MACHINE=$(uname -m)

if [ "$MACHINE" = aarch64 ]; then
    ARCH=arm
else
    ARCH=x64
fi

echo Installing Antigravity desktop
curl -sSfL https://storage.googleapis.com/antigravity-public/antigravity-hub/2.0.10-5119448496078848/linux-${ARCH}/Antigravity.tar.gz | \
    tar -zxf - -C /opt/
ln -s /opt/Antigravity-${ARCH} /opt/Antigravity-Desktop

echo Installing Antigravity IDE
curl -sSfL https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/2.0.3-6242596486512640/linux-${ARCH}/Antigravity%20IDE.tar.gz | \
    tar -zxf - -C /opt/

echo Installing Antigravity CLI
curl -sSfL https://antigravity.google/cli/install.sh | bash -s -- -d /opt/bin
ln -s /opt/bin/agy /usr/local/bin/
