#!/usr/bin/env bash
set -e

read -n1 -p "Enter \"Y\" to Redownload Dotfiles (Press any other key to Skip*) : " redownload_dotfiles
echo ""

if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
echo "All the contents for $HOME directory will be replaced by https://github.com/arpanrec/dotfiles/tree/bash-zsh"
echo "Double check the files present in https://github.com/arpanrec/dotfiles/tree/bash-zsh"
unset redownload_dotfiles
read -n1 -p "Enter \"Y\" to If you still wanna get the contents (Press any other key to Skip*) : " redownload_dotfiles
echo ""
if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
read -n1 -p "Enter \"Y\" to create softlink of gitconfig $HOME/.dotfiles/gitconfig => $HOME/.gitconfig (Press any other key to Skip*) : " redownload_dotfiles_link_git_config
echo ""
fi
fi

if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
echo "# Re-download Dotfiles Start"

redownload_dotfiles_old_backup_dir="${HOME}/.dotfiles/backup/$(date +%s)"

mkdir -p "${redownload_dotfiles_old_backup_dir}"
echo "Backup Old Files to ${redownload_dotfiles_old_backup_dir}"

if [ -f "$HOME/.bashrc" ]; then
cp "$HOME/.bashrc" "${redownload_dotfiles_old_backup_dir}/.bashrc"
fi

if [ -f "$HOME/.zshrc" ]; then
cp "$HOME/.zshrc" "${redownload_dotfiles_old_backup_dir}/.zshrc"
fi

if [ -f "$HOME/.bash_profile" ]; then
cp "$HOME/.bash_profile" "${redownload_dotfiles_old_backup_dir}/.bash_profile"
fi

if [ -f "$HOME/.aliasrc" ]; then
cp "$HOME/.aliasrc" "${redownload_dotfiles_old_backup_dir}/.aliasrc"
fi

if [ -d "$HOME/.ssh" ]; then
cp -R "$HOME/.ssh" "${redownload_dotfiles_old_backup_dir}/"
fi

if [ -f "$HOME/.gitconfig" ]; then
cp -R "$HOME/.gitconfig" "${redownload_dotfiles_old_backup_dir}/.gitconfig"
fi

rm -rf "${HOME}/.dotfiles/bare"
git clone --depth=1 --single-branch --branch bash-zsh https://github.com/arpanrec/dotfiles.git --bare "$HOME/.dotfiles/bare"
git --git-dir="$HOME/.dotfiles/bare" --work-tree="$HOME" config status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles/bare" --work-tree="$HOME" config branch.bash-zsh.remote origin
git --git-dir="$HOME/.dotfiles/bare" --work-tree="$HOME" config branch.bash-zsh.merge refs/heads/bash-zsh
git --git-dir="$HOME/.dotfiles/bare" --work-tree="$HOME" reset --hard HEAD

if [[ "$redownload_dotfiles_link_git_config" == "Y" || "$redownload_dotfiles_link_git_config" == "y" ]]; then
rm -rf "$HOME/.gitconfig"
ln -s "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"
fi

echo "# Re-download Dotfiles END"
fi
