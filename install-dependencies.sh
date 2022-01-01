#!/bin/bash
mkdir -p /var/lib/pacman/local
mkdir -p /var/lib/pacman/sync
pacman -Sy
pacman -S mksquashfs xorriso
