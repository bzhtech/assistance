#!/bin/bash

iso="archlinux-2021.12.01-x86_64.iso"
origin="http://archlinux.mirrors.ovh.net/archlinux/iso/2021.12.01"

if [ ! -z ${GITHUB_WORKSPACE} ];
then
    project="${GITHUB_WORKSPACE}/self"
else 
    project="$(pwd)"
fi

function create_CustomISO() 
{
   # create iso file
   iso_label="ARCH_202112"

   sudo xorriso -as mkisofs \
       -iso-level 3 \
       -full-iso9660-filenames \
       -volid "${iso_label}" \
       -eltorito-boot syslinux/isolinux.bin \
       -eltorito-catalog syslinux/boot.cat \
       -no-emul-boot -boot-load-size 4 -boot-info-table \
       -isohybrid-mbr $project/customiso/syslinux/isohdpfx.bin \
       -output $project/output/assistance.iso \
       $project/customiso
}

# clean old mounted chrooted paths
for montage in $(sudo mount | grep self | awk '{print $3}')
do
   sudo umount -l "$montage"
done

# prepare and clean need folders
[[ -d $project/customiso ]] && sudo rm -rf $project/customiso
[[ ! -d /tmp/archiso ]] && mkdir /tmp/archiso
[[ ! -d $project/customiso ]] && mkdir -p $project/customiso
[[ ! -d $project/output ]] && mkdir -p $project/output
[[ ! -d $project/src ]] && mkdir $project/src
[[ ! -f $project/src/$iso ]] && curl $origin/$iso -o $project/src/$iso

# install dependencies
#$project/install-dependencies.sh

# grab iso content to local directory
osirrox -indev $project/src/$iso -extract / $project/customiso

# extract squashfs
cd $project/customiso/arch/x86_64
sudo unsquashfs airootfs.sfs
sudo cp ../boot/x86_64/vmlinuz-linux squashfs-root/boot/vmlinuz-linux
sudo rm squashfs-root/etc/resolv.conf
sudo cp /etc/resolv.conf squashfs-root/etc/

# to launch as root user
sudo cp $project/update-pacman-database.sh squashfs-root/root/
sudo cp $project/add-packages-to-arch.sh squashfs-root/root/
sudo cp $project/useradd.sh squashfs-root/root/

# to launch as archlinux user
sudo cp $project/add-aurutils-package-for-aur.sh squashfs-root/etc/skel/
sudo cp $project/install-teamviewer.sh squashfs-root/etc/skel/
sudo cp $project/enable-teamviewer.sh squashfs-root/etc/skel/

# add support service
#cp $project/systemd/secure-tunnel@.service squashfs-root/etc/systemd/system/

# prepare mounts for chroot
sudo mount --bind /proc squashfs-root/proc
sudo mount --bind /dev squashfs-root/dev

# update pacman in chroot , install packages and create user for X11 launch
sudo chroot squashfs-root /root/update-pacman-database.sh
sudo chroot squashfs-root /root/add-packages-to-arch.sh
sudo chroot squashfs-root /root/useradd.sh

# install aur utils pour aur package and teamviewer install
sudo chroot squashfs-root su - archlinux /home/archlinux/add-aurutils-package-for-aur.sh
sudo chroot squashfs-root su - archlinux /home/archlinux/install-teamviewer.sh
sudo chroot squashfs-root su - archlinux /home/archlinux/enable-teamviewer.sh

# install graphical interface
sudo cp $project/add-graphical-interface.sh squashfs-root/root/
sudo chroot squashfs-root /root/add-graphical-interface.sh

# create update kernel and move new kernel from squashfs to new iso directory
sudo cp $project/upgrade-kernel.sh squashfs-root/root/
sudo chroot squashfs-root /root/upgrade-kernel.sh
sudo mv squashfs-root/boot/vmlinuz-linux $project/customiso/arch/boot/x86_64/vmlinuz
sudo mv squashfs-root/boot/initramfs-linux.img $project/customiso/arch/boot/x86_64/archiso.img
sudo rm squashfs-root/boot/initramfs-linux-fallback.img

# clean pacman cache
sudo cp $project/clean-pacman-cache.sh squashfs-root/root/
sudo chroot squashfs-root /root/clean-pacman-cache.sh

# mv package list from squashfs to new iso directory
sudo mv squashfs-root/pkglist.txt $project/customiso/arch/pkglist.x86_64.txt

# umount dev proc chroot before make new squashfs
cd $project/customiso/arch/x86_64

sudo umount -l squashfs-root/proc
sudo umount -l squashfs-root/dev

# recreate squashfs file
sudo rm airootfs.sfs
sudo mksquashfs squashfs-root airootfs.sfs

# clean old iso file
cd $project/customiso
sudo rm -rf arch/x86_64/squashfs-root
sudo rm -f output/arch-custom.iso

# create new iso file
create_CustomISO
