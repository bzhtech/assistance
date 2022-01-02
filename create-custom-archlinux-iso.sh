#!/bin/bash

iso="archlinux-2021.12.01-x86_64.iso"
origin="http://archlinux.mirrors.ovh.net/archlinux/iso/2021.12.01"

project="${GITHUB_WORKSPACE}/self"

function create_CustomISO() 
{
   # create iso file
   iso_label="mycustom_iso"

   sudo xorriso -as mkisofs \
       -iso-level 3 \
       -full-iso9660-filenames \
       -volid "${iso_label}" \
       -eltorito-boot syslinux/isolinux.bin \
       -eltorito-catalog syslinux/boot.cat \
       -no-emul-boot -boot-load-size 4 -boot-info-table \
       -isohybrid-mbr $project/customiso/syslinux/isohdpfx.bin \
       -output $project/output/arch-custom.iso \
       $project/customiso
}

for montage in $(sudo mount | grep self | awk '{print $3}')
do
   sudo umount -l "$montage"
done

echo "PATH $(pwd)"

[[ -d $project/customiso ]] && rm -rf $project/customiso
[[ ! -d /tmp/archiso ]] && mkdir /tmp/archiso
[[ ! -d $project/customiso ]] && mkdir -p $project/customiso
[[ ! -d $project/output ]] && mkdir -p $project/output
[[ ! -d $project/src ]] && mkdir $project/src
[[ ! -f $project/src/$iso ]] && curl $origin/$iso -o $project/src/$iso

# install dependencies
#$project/install-dependencies.sh

# grab iso content to local directory
osirrox -indev $project/src/$iso -extract / $project/customiso
#mount -t iso9660 -o loop $project/src/$iso /tmp/archiso
#cp -a /tmp/archiso/. $project/customiso
#umount /tmp/archiso

# extract squashfs
cd $project/customiso/arch/x86_64
unsquashfs airootfs.sfs
cp ../boot/x86_64/vmlinuz-linux squashfs-root/boot/vmlinuz-linux
rm squashfs-root/etc/resolv.conf
cp /etc/resolv.conf squashfs-root/etc/

cp $project/update-pacman-database.sh squashfs-root/root/
cp $project/upgrade-kernel.sh squashfs-root/root/
cp $project/add-packages-to-arch.sh squashfs-root/root/
cp $project/add-aurutils-package-for-aur.sh squashfs-root/etc/skel/
cp $project/install-teamviewer.sh squashfs-root/etc/skel/
cp $project/useradd.sh squashfs-root/root/

# add support service
#cp $project/systemd/secure-tunnel@.service squashfs-root/etc/systemd/system/
# add config for support service
#cp $project/systemd/service-tunnel@grozours.fr squashfs-root/etc/default/

sudo mount --bind /proc squashfs-root/proc
sudo mount --bind /dev squashfs-root/dev

# chroot into extracted squashfs
chroot squashfs-root /root/update-pacman-database.sh
chroot squashfs-root /root/add-packages-to-arch.sh
chroot squashfs-root /root/useradd.sh

# install aur utils pour aur package and teamviewer install
chroot squashfs-root su - archlinux /home/archlinux/add-aurutils-package-for-aur.sh
chroot squashfs-root su - archlinux /home/archlinux/install-teamviewer.sh

# create update kernel and move new kernel from squashfs to new iso directory
chroot squashfs-root /root/upgrade-kernel.sh
mv squashfs-root/boot/vmlinuz-linux $project/customiso/arch/boot/x86_64/vmlinuz
mv squashfs-root/boot/initramfs-linux.img $project/customiso/arch/boot/x86_64/archiso.img
rm squashfs-root/boot/initramfs-linux-fallback.img

# mv package list from squashfs to new iso directory
mv squashfs-root/pkglist.txt $project/customiso/arch/pkglist.x86_64.txt

# umount dev proc chroot before make new squashfs
cd $project/customiso/arch/x86_64

sudo umount -l squashfs-root/proc
sudo umount -l squashfs-root/dev

# recreate squashfs file
rm airootfs.sfs
mksquashfs squashfs-root airootfs.sfs

# create new iso file
cd $project/customiso
rm -rf arch/x86_64/squashfs-root
rm -f arch-custom.iso

create_CustomISO
