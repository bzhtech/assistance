#!/bin/bash
pacman -S --noconfirm lightdm lightdm-gtk-greeter lxqt xf86-input-libinput xorg-server xorg-xinput xorg-xinit xf86-video-intel xf86-input-evdev xf86-video-fbdev xf86-video-vesa network-manager-applet firefox
systemctl enable lightdm

# switch from iwd to NetworkManager 
systemctl disable iwd
systemctl enable NetworkManager

# apply autologin on lightdm
sed -i "s/#pam-service=/pam-service=/g" /etc/lightdm/lightdm.conf
sed -i "s/#pam-autologin-service=/pam-autologin-service=/g" /etc/lightdm/lightdm.conf
sed -i "s/#autologin-user=/autologin-user=archlinux/g" /etc/lightdm/lightdm.conf
sed -i "s/#autologin-user-timeout=/autologin-user-timeout=/g" /etc/lightdm/lightdm.conf
sed -i "s/#user-session=default/user-session=lxqt/g" /etc/lightdm/lightdm.conf
