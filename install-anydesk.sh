#!/bin/bash
aur fetch anydesk-bin
cd anydesk-bin
makepkg -si --noconfirm
cd ..
rm -rf anydesk-bin
