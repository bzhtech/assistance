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

# repopulate pacman gpg keys
pacman-key --populate archlinux

#pid_gpg_to_kill=$(ps -eaf | grep [gpg]-agent | awk '{print $2}')
#kill -9 $pid_gpg_to_kill


