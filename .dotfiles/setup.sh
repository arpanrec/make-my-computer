#!/bin/bash
set -xe

mkdir -p ${HOME}/.dotfiles
rm -rf $HOME/.dotfiles/bare
rm -rf $HOME/.bash_it
git clone https://github.com/arpanrec/bash-it --depth=1 ~/.bash_it
git clone https://github.com/arpanrec/dotfiles.git --bare $HOME/.dotfiles/bare
echo "alias config=\"git --git-dir=\$HOME/.dotfiles/bare --work-tree=\$HOME\"" >> $HOME/.bashrc
source $HOME/.bashrc

git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME config status.showUntrackedFiles no

if hash bw jq &> /dev/null ; then
    BW_STATUS="$(bw status | jq .status -r)"
    if [ $BW_STATUS != "unlocked" ] ; then
        echo "Skipping some mandatory file download"
        exit
    fi
    
    bw sync

    BW_DOTFILES_ITEM=$(bw get item dotfiles | jq .id -r)

    echo ${BW_DOTFILES_ITEM}
    mkdir -p ${HOME}/.config/rclone
    mkdir -p ${HOME}/.tmp
    bw get attachment "rclone.conf" --itemid ${BW_DOTFILES_ITEM} --output ${HOME}/.config/rclone/rclone.conf
    bw get attachment ".git-credentials" --itemid ${BW_DOTFILES_ITEM} --output ${HOME}/.git-credentials
    bw get attachment "arpan.asc" --itemid ${BW_DOTFILES_ITEM} --output ${HOME}/.tmp/arpan.asc
    gpg --import ${HOME}/.tmp/arpan.asc
    rm -rf ${HOME}/.tmp/arpan.asc

fi
