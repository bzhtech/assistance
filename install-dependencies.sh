#!/bin/bash
mkdir -p /var/lib/pacman/local
mkdir -p /var/lib/pacman/sync
pacman -Tv --debug
pacman -Sy --debug
pacman -S --debug mksquashfs xorriso
