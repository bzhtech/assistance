#!/bin/bash
aur fetch teamviewer
cd teamviewer
makepkg -si --noconfirm
cd ..
rm -rf teamviewer
