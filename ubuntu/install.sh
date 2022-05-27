#!/usr/bin/env bash
set -e

sudo apt-get install -y linux-firmware linux-headers-"$(uname -r)" linux-modules-extra-"$(uname -r)" \
 dkms network-manager net-tools build-essential openssh-server dkms dhcpcd5

sudo apt-get install ethtool libgnome-bg-4-1 libmspack0 libntfs-3g89 libxmlsec1-openssl zerofree -y

# Add VS Code Repo
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg

sudo echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get install fonts-liberation software-properties-common apt-transport-https wget ca-certificates gnupg2 -y
sudo add-apt-repository multiverse -y

sudo apt update

sudo apt-get install -y apt-transport-https git dkms gnupg2 curl zsh terminator htop

sudo apt-get install -y linux-firmware linux-headers-"$(uname -r)" dkms \
    network-manager net-tools build-essential openssh-server \
    dkms dhcpcd5

if hash google-chrome-stable &>/dev/null; then
	echo "google-chrome is installed!"
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm -rf google-chrome-stable_current_amd64.deb
fi

# Install
# sudo apt-get install code -y # Install from userapps
sudo apt-get install sublime-text -y

# Install java from user apps
# sudo apt-get install openjdk-17-jdk maven gradle gradle-doc groovy groovy-doc -y

sudo apt-get install -y python3-pip

# Install from userapps
# sudo apt-get install -y golang

# Codecs
# sudo apt-get install ubuntu-restricted-extras -y
sudo apt-get install -y ffmpegthumbnailer ffmpeg vlc eog heif-gdk-pixbuf heif-thumbnailer

# Gnome

__gnometweaktool_apt_search=$(apt-cache search --names-only 'gnome-tweak-tool')
if [[ -n "$__gnometweaktool_apt_search" ]] ; then
 echo "Variable is set"  ;
fi

__gnometweaks_apt_search=$(apt-cache search --names-only 'gnome-tweaks')
if [[ -n "$__gnometweaks_apt_search" ]] ; then
	echo "Variable is set"  ;
fi

sudo apt install -y gnome-shell-extensions

# Fuse is needed for AppImage
sudo apt install -y fuse

# Service
sudo systemctl enable NetworkManager
sudo systemctl enable dhcpcd
sudo systemctl enable ssh

echo "END Of Script"
