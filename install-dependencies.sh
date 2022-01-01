#!/bin/bash

# https://github.com/qutebrowser/qutebrowser/commit/478e4de7bd1f26bebdcdc166d5369b2b5142c3e2
curl -fsSL "https://repo.archlinuxcn.org/x86_64/glibc-linux4-2.33-4-x86_64.pkg.tar.zst" | bsdtar -C / -xvf -
pacman -Sy
pacman -S mksquashfs xorriso
