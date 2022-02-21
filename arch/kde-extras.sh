#!/usr/bin/env bash
set -e

pack_extars+=('xclip' 'xsel' 'wl-clipboard')
pack_extars+=('hunspell-en_us' 'hunspell-en_gb') # For some spelling check
pack_extars+=('cryfs' 'encfs' 'gocryptfs')       # For kde vault
pack_extars+=('texlive-core' 'libwmf' 'scour' 'pstoedit' 'fig2dev')
pack_extars+=('gtk-engine-murrine' 'gtk-engines')
pack_extars+=('libotr')
pack_extars+=(
    'gsfonts' 'apparmor' 'xsane' 'imagescan'
    'python-pysmbc'
)
pack_extars+=('htop' 'mlocate' 'inetutils' 'net-tools')
pack_extars+=('discord' 'gimp' 'webkit2gtk' 'gnuplot' 'sysstat')

pacman -S --needed --noconfirm "${pack_extars[@]}"

# VS Code Fix https://wiki.archlinux.org/title/Visual_Studio_Code#Git:_ssh_askpass:_exec(/usr/lib/ssh/ssh-askpass):_No_such_file_or_directory
ln /usr/bin/ksshaskpass /usr/lib/ssh/ssh-askpass
