#!/usr/bin/env bash
set -e

pack_extars+=(
    'gsfonts' 'apparmor' 'xsane' 'imagescan'
    'python-pysmbc'
)
pack_extars+=('libotr')
pack_extars+=('xclip' 'xsel' 'wl-clipboard')
pack_extars+=('htop' 'mlocate' 'inetutils' 'net-tools')
pack_extars+=('discord' 'gimp' 'gnuplot' 'sysstat')
pacman -S --needed --noconfirm "${pack_extars[@]}"
