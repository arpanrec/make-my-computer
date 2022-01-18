set -ex

sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf remove -y xorg-x11-drv-nouveau

sudo dnf install -y nvidia-settings akmod-nvidia xorg-x11-drv-nvidia-cuda gwe
sudo dnf install -y steam

sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y libglvnd-devel cmake ncurses-devel git 

# chsh
sudo dnf install -y util-linux-user

# JAVA
sudo dnf install -y java-11-openjdk-devel maven-openjdk17 python3-pip

sudo dnf install -y google-chrome-stable vim zsh neofetch rclone rsync \
      terminator \
      p7zip p7zip-plugins zip unzip \
      htop openssl
# flatpak install flathub com.mattermost.Desktop -y
# Gnome Things
sudo dnf install -y seahorse gnome-tweaks gnome-extensions-app \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-workspace-indicator \
    libappindicator libappindicator-gtk3 libindicator \
    gtkmm4.0 gtkmm4.0-doc gtkmm4.0-devel \
    gtkmm30 gtkmm30-doc gtkmm30-devel mingw32-gtkmm30 mingw64-gtkmm30 \
    gtkmm24 gtkmm24-docs gtkmm24-devel mingw32-gtkmm24 mingw64-gtkmm24 \
    jalv-gtkmm

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install -y code
sudo echo y | sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)

sudo dnf install -y https://github.com/bitwarden/desktop/releases/download/v1.30.0/Bitwarden-1.30.0-x86_64.rpm

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf -y install sublime-text
