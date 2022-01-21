#!/bin/bash

# create pacman cache
mkdir -p /var/cache/pacman/pkg

# remove checkspace pacman
sed -i "s/CheckSpace/#CheckSpace/g" /etc/pacman.conf

# populate pacman
pacman-key --init
pacman-key --populate archlinux

# update pacman database
pacman -Sy
