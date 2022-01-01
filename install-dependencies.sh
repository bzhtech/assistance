#!/bin/bash

# https://github.com/qutebrowser/qutebrowser/commit/478e4de7bd1f26bebdcdc166d5369b2b5142c3e2

patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
bsdtar -C / -xvf "$patched_glibc"

mkdir -p /var/lib/pacman/local
mkdir -p /var/lib/pacman/sync
#pacman -Tv --debug
pacman -Sy --debug
pacman -Syu --noconfirm --debug mksquashfs xorriso
