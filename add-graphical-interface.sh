#!/bin/bash
pacman -S --noconfirm lightdm lightdm-gtk-greeter lxqt xf86-input-libinput xorg-server xorg-xinput xorg-xinit xf86-video-intel xf86-input-evdev xf86-video-fbdev xf86-video-vesa network-manager-applet firefox
systemctl enable lightdm

# apply autologin on lightdm
sed -i "s/#pam-service=/pam-service=/g" /etc/lightdm/lightdm.conf
sed -i "s/#pam-autologin-service=/pam-autologin-service=/g" /etc/lightdm/lightdm.conf
sed -i "s/#autologin-user-timeout=/autologin-user-timeout=/g" /etc/lightdm/lightdm.conf
echo -e "autologin-user=archlinux" >> /etc/lightdm/lightdm.conf
