#!/bin/bash

# add wheel group to sudoers without password
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
groupadd -r autologin
useradd archlinux -m -G users,wheel,audio,video,adm,optical,storage,power,network,autologin -p $(perl -e 'print crypt($ARGV[0], "password")' 'archlinux')
