#!/usr/bin/env bash
set -e

git clone "https://aur.archlinux.org/yay.git" ~/yay --depth=1
cd ${HOME}/yay
makepkg -si --noconfirm
