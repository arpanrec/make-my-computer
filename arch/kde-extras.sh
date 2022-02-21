#!/usr/bin/env bash
set -e

pack_extars+=('python-packaging' 'fuse' 'fuse2' 'fuse3')
pack_extars+=('xclip' 'xsel' 'wl-clipboard')
pack_extars+=('lm_sensors')
pack_extars+=('gnu-free-fonts' 'hunspell' 'hunspell-en_us' 'hunspell-en_gb' 'sonnet') # For some spelling check
pack_extars+=('cryfs' 'encfs' 'gocryptfs')                                            # For kde vault
pack_extars+=('taglib')                                                               #  Audio meta data editor
pack_extars+=('ghostscript' 'libxml2' 'jasper' 'texlive-core' 'libwmf' 'scour' 'pstoedit' 'fig2dev')
pack_extars+=('gtk-engine-murrine' 'gtk-engines')
pack_extars+=('libotr')
pack_extars+=(
    'gsfonts' 'apparmor' 'xsane' 'imagescan' 'sane' 'ghostscript'
    'dbus-python' 'python-pyqt5' 'python-gobject' 'python-pysmbc'
)
pack_extars+=('htop' 'mlocate' 'inetutils' 'net-tools')
pack_extars+=('discord' 'gimp' 'webkit2gtk' 'gnuplot' 'sysstat')
