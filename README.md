# assistance
bootable linux iso image with teamviewer.
   
you can have support on a computer with some actual hard drive system issue,  
booting for an external drive or flashdrive  

## install iso to usb drive ( flash ou usb hardrive)
! warning !  
! data on drive will be deleted !  

### correct /dev/s** to your usb drive

### on linux : use dd ou gnome drive tool
dd if=assistance.iso of=/dev/s**  
### on windows : use rufus or any other tool

## boot from usb drive ( bios in legacy mode)
todo : add UEFI support to iso  

## graphical interface autologin is enabled :

for information / in case  

user : archlinux  
password : archlinux  

## change your keyboard settings ( default is "en" keyboard )
with terminal :  

### for french keyboard
setxkbmap fr  
