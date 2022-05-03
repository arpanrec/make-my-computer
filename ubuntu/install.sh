#!/usr/bin/env bash
set -e

# Add VS Code Repo
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb

sudo wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

sudo echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo add-apt-repository multiverse -y

sudo apt update

sudo apt-get install -y apt-transport-https git dkms gnupg2 curl zsh terminator htop

sudo apt-get install -y linux-firmware linux-headers-"$(uname -r)" dkms \
    network-manager net-tools build-essential openssh-server \
    dkms dhcpcd5

sudo dpkg -i google-chrome-stable_current_amd64.deb

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
sudo apt install -y gnome-tweak-tool gnome-shell-extensions

# Fuse is needed for AppImage
sudo apt install -y fuse

# Service
sudo systemctl enable NetworkManager
sudo systemctl enable dhcpcd
sudo systemctl enable ssh

rm -rf google-chrome-stable_current_amd64.deb

echo "END Of Script"
