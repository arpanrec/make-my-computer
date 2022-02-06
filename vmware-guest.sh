#!/bin/bash
set -e

# Add VS Code Repo
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb

sudo add-apt-repository multiverse -y

sudo apt update

sudo apt-get install -y apt-transport-https git dkms gnupg2 curl zsh neovim

sudo apt-get install -y linux-firmware linux-headers-$(uname -r) dkms \
network-manager net-tools build-essential openssh-server \
dkms dhcpcd5

# Install VSCode
sudo apt-get install code -y

# Install java
sudo apt-get install openjdk-17-jdk maven gradle gradle-doc groovy groovy-doc -y

sudo apt-get install -y python3-pip

sudo apt-get install -y golang

# Codecs
# sudo apt-get install ubuntu-restricted-extras -y
sudo apt-get install -y ffmpegthumbnailer ffmpeg vlc eog

# Gnome
sudo apt install -y gnome-tweak-tool

# Service
sudo systemctl enable NetworkManager
sudo systemctl enable dhcpcd
sudo systemctl enable ssh

