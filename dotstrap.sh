#!/usr/bin/env bash
set -e

__bare_backup_directory="${HOME}/.backup/dotfiles-bare-setup-$(date +%s)"
__backup_directory="${HOME}/.backup/dotfiles-$(date +%s)"
__gitbare_directory="${HOME}/.dotfiles"
__git_remote='https://github.com/arpanrec/dotfiles.git'

echo "-----------------------------------------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------------------------------------"
echo ""
echo "                               Init Dot Files - Tracking dotfiles directly with Git"
echo ""
echo "-----------------------------------------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Home directory [${HOME}] file will be treated as Git Working Directory"
echo "Git Directory/Git Bare will be located at ${__gitbare_directory}"
echo ""
echo "** config ** is the magic word"
echo "In order to track any file just use the ** config ** command and treat it as ** git ** command"
echo ""
echo "If you want to track any file/change 'config add <path>'"
echo "In order to commit changes 'config commit -m\"<commit message>\"'"
echo "In order to push your changes 'config push'"
echo ""

mkdir -p "${__bare_backup_directory}"

read -n1 -p "Enter \"Y\" to Start (Press any other key to Skip*) : " __redownload_dotfiles
echo ""
echo ""

if [[ "${__redownload_dotfiles}" == "Y" || "${__redownload_dotfiles}" == "y" ]]; then
    echo "#######################################################################################################################################################"
    echo "Downloading existing dotfiles in ${__gitbare_directory} from ${__git_remote}"
    echo "#######################################################################################################################################################"

    if [[ -f "${__gitbare_directory}" || -d "${__gitbare_directory}" ]]; then
        echo ""
        echo "${__gitbare_directory} Already exists"
        echo ""
        read -n1 -p "Enter \"y\" to backup old ${__gitbare_directory} to ${__bare_backup_directory} (Press any other key to Skip*) : " __backup_old_gitbare
        echo ""
        echo ""
        if [[ "${__backup_old_gitbare}" == "Y" || "${__backup_old_gitbare}" == "y" ]]; then
            mkdir -p "${__bare_backup_directory}"
            cp -r "${__gitbare_directory}" "${__bare_backup_directory}"
            rm -rf "${__gitbare_directory}"
            echo "Back up completed and cleaned up old files"
            echo ""
        else
            echo ""
            echo "Done"
            echo ""
            exit 0
        fi
    fi
    echo ""
    git clone --depth=1 --single-branch --branch main "${__git_remote}" --bare "${__gitbare_directory}"
    echo ""
    echo "#######################################################################################################################################################"
    echo "Finish Downloding Dotfiles"
    echo "#######################################################################################################################################################"
fi

echo "#######################################################################################################################################################"
echo "Apply new dotfiles?"
echo "#######################################################################################################################################################"
echo ""
echo "Old dotfiles will be backdup at ${__backup_directory}"
echo ""
read -n1 -p "Enter \"Y\" to start (Press any other key to Skip*) : " __git_bare_reset
echo ""
echo ""
if [[ "${__git_bare_reset}" == "Y" || "${__git_bare_reset}" == "y" ]]; then

    mkdir -p "${__backup_directory}"

    # __files_to_backup=( $(git --git-dir="${HOME}/.dotbare" --work-tree=${HOME} ls-files) )

    __files_to_backup=(
        ".bash_it/themes/makemyarch/makemyarch.theme.bash"
        ".config/Code/User/keybindings.json"
        ".config/Code/User/settings.json"
        ".config/konsave/profiles/nordic"
        ".config/nvim/init.vim"
        ".config/systemd/user/google-drive.service"
        ".config/systemd/user/google-photos.service"
        ".config/systemd/user/onedrive.service"
        ".config/systemd/user/work-drive.service"
        ".config/terminator/config"
        ".config/konsolerc"
        ".gnupg/gpg-agent.conf"
        ".gnupg/sshcontrol"
        ".local/share/konsole/arpanrec.keytab"
        ".local/share/konsole/arpanrec.profile"
        ".local/share/konsole/BlackOnLightYellow.colorscheme"
        ".local/share/konsole/GreenOnBlack.colorscheme"
        ".local/share/konsole/Nordic.colorscheme"
        ".local/share/konsole/Solarized.colorscheme"
        ".ssh/config"
        ".symbolic/gitconfig"
        ".aliasrc"
        ".bash_profile"
        ".bashrc"
        ".exporterrc"
        ".p10k.zsh"
        ".zshrc"
    )

    for file_to_backup in ${__files_to_backup[@]}; do
        echo "Backup ${HOME}/${file_to_backup}"
        if [[ -f "${HOME}/${file_to_backup}" || -d "${HOME}/${file_to_backup}" ]]; then
            echo "Backing up to ${__backup_directory}/${file_to_backup}"
            mkdir -p "$(dirname "${__backup_directory}/${file_to_backup}")"
            cp -r ${HOME}/${file_to_backup} ${__backup_directory}/${file_to_backup}
        else
            echo "File not found"
        fi
    done

    git --git-dir="${HOME}/.dotbare" --work-tree=${HOME} reset --hard HEAD

fi

echo "100%"
