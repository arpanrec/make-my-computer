#!/usr/bin/env bash
set -e

read -n1 -p "Enter \"Y\" to Dotfiles (Press any other key to Skip*) : " redownload_dotfiles
echo ""

if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
echo "# Download Dotfiles Start"

git clone --depth=1 --single-branch --branch main https://github.com/arpanrec/dotfiles.git --bare "$HOME/.dotbare"

git --git-dir="$HOME/.dotbare" --work-tree=$HOME checkout HEAD -- $HOME/.setup

echo "# Download Dotfiles END"
fi
