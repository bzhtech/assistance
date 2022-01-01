#!/bin/bash

# extract squashfs
cd $HOME/self/customiso/arch/x86_64
cp /etc/resolv.conf squashfs-root/etc/

montages=$(sudo mount | grep arch_custom | awk '{print $3}' | wc -l)
if [ "$montages" -ne "2" ];
then	
    mount --bind /proc squashfs-root/proc
    mount --bind /dev squashfs-root/dev
fi

# chroot into extracted squashfs
chroot squashfs-root
