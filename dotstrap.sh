#!/usr/bin/env bash
set -e

cd ${HOME}

__bare_backup_directory="${HOME}/.backup/dotfiles-bare-setup-$(date +%s)"
__git_remote='https://github.com/arpanrec/dotfiles.git'
__gitbare_directory="${HOME}/.dotfiles"
__setup_script_dir="${HOME}/.setup"
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
    git --git-dir="${__gitbare_directory}" --work-tree="$HOME" config status.showUntrackedFiles no
    git --git-dir="${__gitbare_directory}" --work-tree="$HOME" config branch.main.remote origin
    git --git-dir="${__gitbare_directory}" --work-tree="$HOME" config branch.main.merge refs/heads/main
    echo ""
    echo "#######################################################################################################################################################"
    echo "Finish Downloding Dotfiles"
    echo "#######################################################################################################################################################"
fi
echo ""
echo "#######################################################################################################################################################"
echo "Checkout the Automated setup scripts?"
echo "#######################################################################################################################################################"
echo ""
echo "Few automation scripts are avalible at ${__setup_script_dir}"
echo ""
read -n1 -p "Enter \"Y\" to checkout (Press any other key to Skip*) : " __git_checkout_setup
echo ""
echo ""
if [[ "${__git_checkout_setup}" == "Y" || "${__git_checkout_setup}" == "y" ]]; then

    if [[ -f "${__setup_script_dir}" || -d "${__setup_script_dir}" ]]; then

        echo ""
        echo "${__setup_script_dir} Already exists"
        echo ""
        read -n1 -p "Enter \"y\" to backup old ${__setup_script_dir} to ${__bare_backup_directory} (Press any other key to Skip*) : " __backup_setup
        echo ""
        echo ""
        if [[ "${__backup_setup}" == "Y" || "${__backup_setup}" == "y" ]]; then
            mkdir -p "${__bare_backup_directory}"
            cp -r "${__setup_script_dir}" "${__bare_backup_directory}"
            echo "Back up completed and cleaned up old files"
            echo ""
        else
            echo ""
            echo "Done"
            echo ""
            exit 0
        fi

    fi

    git --git-dir="${__gitbare_directory}" --work-tree="$HOME" checkout HEAD -- "${__setup_script_dir}"

fi

echo "100%"
