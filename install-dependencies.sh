#!/bin/bash
mkdir -p /var/lib/pacman/local
mkdir -p /var/lib/pacman/sync
#pacman -Tv --debug
#pacman -Sy --debug
pacman -Syu --noconfirm --debug mksquashfs xorriso
