#!/bin/bash
set -e

rm -rf $HOME/.dotfiles/bare
git clone https://github.com/arpanrec/dotfiles.git --bare $HOME/.dotfiles/bare
echo "alias config=\"git --git-dir=\$HOME/.dotfiles/bare --work-tree=\$HOME\"" >> $HOME/.bashrc
source $HOME/.bashrc
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME config status.showUntrackedFiles no
