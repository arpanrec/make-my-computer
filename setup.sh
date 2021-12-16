#!/usr/bin/env bash
set -e

echo "--------------------------------------"
echo "--     Time zone : Asia/Kolkata     --"
echo "--------------------------------------"
timedatectl set-timezone Asia/Kolkata
hwclock --systohc
timedatectl set-ntp true

echo "--------------------------------------"
echo "--       Localization : UTF-8       --"
echo "--------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
localectl --no-ask-password set-keymap us

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[  $TOTALMEM -gt 8000000 ]]; then
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

read -p "Please name your machine:" nameofmachine
echo $nameofmachine > /etc/hostname

pacman -Sy --noconfirm

ALL_PAKGS=( 'pacman-contrib' 'curl' 'reflector' 'rsync' 'grub' 'efibootmgr' 'dhcpcd' 'networkmanager' 'openssh' 'git' 'vim' 'base' 'base-devel' 'linux' 'linux-firmware' 'python-pip' 'lvm2' 'linux-headers' 'unzip' 'zip' 'pigz' 'wget' 'ntfs-3g' 'dhclient' 'ufw' 'docker' 'bash-completion' 'python-packaging' 'python-pip' 'rclone' 'git' 'jdk11-openjdk' 'maven' 'groovy' 'gradle' 'gradle-src' 'gradle-doc' )

echo "--------------------------------------------------"
echo "--determine processor type and install microcode--"
echo "--------------------------------------------------"
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

echo "--------------------------------------------------"
echo "         Graphics Drivers find and install        "
echo "--------------------------------------------------"
if lspci | grep -E "NVIDIA|GeForce"; then
    ALL_PAKGS+=('nvidia')
elif lspci | grep -E "Radeon"; then
    ALL_PAKGS+=('xf86-video-amdgpu')
elif lspci | grep -E "Integrated Graphics Controller"; then
    ALL_PAKGS+=('libvdpau-va-gl' 'lib32-vulkan-intel' 'vulkan-intel' 'libva-intel-driver' 'libva-utils')
fi
sudo mkdir -p "/etc/pacman.d/hooks"
cat <<EOT > "/etc/pacman.d/hooks/nvidia.hook"
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case \$trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOT

sudo mkdir /etc/udev/rules.d/ -p
cat <<EOT > "/etc/udev/rules.d/99-nvidia.rules"
ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c0 -u"
EOT

read -p "Do you want pipewire [Default PulseAudio]? (Y for Yes)" pipewire_yes_no
case $pipewire_yes_no in
    [Yy]* ) ALL_PAKGS+=('wireplumber' 'pipewire' 'pipewire-pulse' 'pipewire-alsa' 'pipewire-jack' 'lib32-pipewire' 'lib32-pipewire-jack');;
    * ) ALL_PAKGS+=('pulseaudio' 'pulseaudio-alsa' 'pulseaudio-bluetooth' 'pulseaudio-equalizer' 'pulseaudio-jack' 'pulseaudio-lirc' 'pulseaudio-zeroconf')
esac

# KDE Base Packages
ALL_PAKGS+=('xorg' 'xorg-xinit' 'phonon-qt5-gstreamer' 'plasma' 'plasma-meta' 'spectacle' 'sonnet' 'hunspell' 'hunspell-en_us' 'hunspell-en_gb' 'cryfs' 'encfs' 'gocryptfs' 'xdg-desktop-portal' 'gwenview')

ALL_PAKGS+=('kwallet-pam' 'kwalletmanager' 'kleopatra' 'partitionmanager' 'skanlite' 'terminator' 'konsole' 'packagekit-qt5' 'qbittorrent' 'kdialog' 'dolphin' 'dolphin-plugins' 'kompare' 'kdegraphics-thumbnailers' 'kimageformats' 'qt5-imageformats' 'kdesdk-thumbnailers' 'ffmpegthumbs' 'raw-thumbnailer' 'taglib' 'noto-fonts' 'noto-fonts-cjk' 'noto-fonts-emoji' 'noto-fonts-extra' 'powerline-fonts' 'ark' 'libavtp' 'lib32-alsa-plugins' 'lib32-jack' 'lib32-libavtp' 'lib32-libsamplerate' 'lib32-libpulse' 'lib32-speexdsp' 'lib32-glib2' 'kvantum-qt5' 'kde-gtk-config' 'fig2dev' 'gvfs' 'pstoedit' 'python-lxml' 'python-numpy' 'scour' 'texlive-core' 'jasper' 'libwmf' 'libxml2' 'ghostscript' 'python' 'ttf-roboto' 'ttf-ubuntu-font-family' 'cantarell-fonts' 'gtk-engine-murrine' 'gtk-engines' 'qt5-declarative' 'qt5-x11extras' 'kdecoration' 'webkit2gtk' 'gnome-keyring' 'seahorse' 'libgnome-keyring' 'appmenu-gtk-module')

pacman -S --noconfirm --needed "${ALL_PAKGS[@]}"

echo "--------------------------------------"
echo "         Setting Root Password        "
echo "--------------------------------------"
getent group sudo || groupadd sudo
getent group wheel || groupadd wheel
echo -e "root\nroot" | passwd

echo "--------------------------------------"
echo "          Enable Boot loader	        "
echo "--------------------------------------"
mkinitcpio -P
grub-install --target=x86_64-efi --bootloader-id=Archlinux --efi-directory=/boot/efi --root-directory=/ --recheck
grub-mkconfig -o /boot/grub/grub.cfg


cat <<EOT > "/etc/profile.d/10-nebula-sw-init-auto.sh"
export PATH=\$HOME/.local/bin:\$PATH:/usr/sbin
export GPG_TTY=\$(tty)
export EDITOR=vim
EOT

cat <<EOT > "/etc/profile.d/10-nebula-java-auto.sh"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export MAVEN_HOME=/opt/maven
export M2_HOME=/opt/maven
export GRADLE_HOME=/usr/share/java/gradle
EOT

echo "--------------------------------------"
echo "       Enable Mandatory Services	    "
echo "--------------------------------------"
systemctl enable dhcpcd
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable systemd-timesyncd
systemctl enable systemd-resolved
systemctl enable iptables
systemctl enable ufw
systemctl enable docker
systemctl enable sddm

read -p "Please enter username:" username
id -u $username &>/dev/null || useradd -s /bin/bash -G docker,wheel -m -d /home/$username $username
passwd $username
