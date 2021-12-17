#!/usr/bin/env bash
set -e

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

PKGS_AUR=('ttf-menlo-powerline-git' 'kde-thumbnailer-apk' 'resvg'
'sweet-gtk-theme-mars'
'kvantum-theme-sweet-mars'
'kvantum-theme-sweet-git'
'sweet-cursor-theme-git'
'sweet-theme-git'
'sweet-folders-icons-git'
'sweet-kde-git'
'sweet-kde-theme-mars-git'
'candy-icons-git'
'layan-kde-git'
'layan-gtk-theme-git'
'layan-cursor-theme-git'
'kvantum-theme-layan-git'
'tela-icon-theme'
'nordic-darker-standard-buttons-theme'
'nordic-darker-theme'
'kvantum-theme-nordic-git'
'sddm-nordic-theme-git'
'nordic-kde-git'
'nordic-theme-git'
'nordic-theme'
'ttf-meslo'
'google-chrome'
'brave-bin'
'timeshift'
'visual-studio-code-bin'
)

yay -S --noconfirm --needed "${PKGS_AUR[@]}"
