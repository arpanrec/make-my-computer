echo "-------------------------------------------------------"
echo "             Install Yay and AUR Packages              "
echo "-------------------------------------------------------"

if ! command -v yay &> /dev/null
then
# Yay User
    id -u nebula_build_user &>/dev/null || useradd -s /bin/bash -m -d /home/nebula_build_user nebula_build_user
    echo "nebula_build_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/10-nebula_build_user
    BASEDIR=$(dirname "$0")
    sudo -H -u nebula_build_user bash -c "$BASEDIR/install_yay.sh"
fi

PKGS_AUR=('ttf-menlo-powerline-git' 'kde-thumbnailer-apk' 'resvg' 'sweet-gtk-theme-mars' 'kvantum-theme-sweet-mars' 'kvantum-theme-sweet-git' 'sweet-cursor-theme-git' 'sweet-theme-git' 'sweet-folders-icons-git' 'sweet-kde-git' 'sweet-kde-theme-mars-git' 'candy-icons-git' 'layan-kde-git' 'layan-gtk-theme-git' 'layan-cursor-theme-git' 'kvantum-theme-layan-git' 'tela-icon-theme' 'nordic-darker-standard-buttons-theme' 'nordic-darker-theme' 'kvantum-theme-nordic-git' 'sddm-nordic-theme-git' 'nordic-kde-git' 'nordic-theme-git' 'nordic-theme' 'ttf-meslo' 'google-chrome' 'brave-bin' 'timeshift' 'visual-studio-code-bin' )

sudo -H -u nebula_build_user bash -c "yay -S --noconfirm --needed ${PKGS_AUR[@]}"
echo "-------------------------------------------------------"
echo "             Install Yay and AUR Packages              "
echo "-------------------------------------------------------"

if ! command -v yay &> /dev/null
then
# Yay User
    id -u nebula_build_user &>/dev/null || useradd -s /bin/bash -m -d /home/nebula_build_user nebula_build_user
    echo "nebula_build_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/10-nebula_build_user
    BASEDIR=$(dirname "$0")
    sudo -H -u nebula_build_user bash -c "$BASEDIR/install_yay.sh"
fi

PKGS_AUR=('ttf-menlo-powerline-git' 'kde-thumbnailer-apk' 'resvg' 'sweet-gtk-theme-mars' 'kvantum-theme-sweet-mars' 'kvantum-theme-sweet-git' 'sweet-cursor-theme-git' 'sweet-theme-git' 'sweet-folders-icons-git' 'sweet-kde-git' 'sweet-kde-theme-mars-git' 'candy-icons-git' 'layan-kde-git' 'layan-gtk-theme-git' 'layan-cursor-theme-git' 'kvantum-theme-layan-git' 'tela-icon-theme' 'nordic-darker-standard-buttons-theme' 'nordic-darker-theme' 'kvantum-theme-nordic-git' 'sddm-nordic-theme-git' 'nordic-kde-git' 'nordic-theme-git' 'nordic-theme' 'ttf-meslo' 'google-chrome' 'brave-bin' 'timeshift' 'visual-studio-code-bin' )

sudo -H -u nebula_build_user bash -c "yay -S --noconfirm --needed ${PKGS_AUR[@]}"
