#!/usr/bin/env bash
set -e
read -p "Please name your machine, (Any other key to skip) : " nameofmachine
read -p "Do you want pipewire? [Default PulseAudio] (Y for pipewire, Any other key to install pulseaudio) : " pipewire_yes_no
read -p "Please enter username(default password: password): (Any other key to skip) :  " username
read -p "Press Y for grub install: (Any other key to skip)  " install_grub
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

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

echo "--------------------------------------"
echo "             Set Host Name            "
echo "--------------------------------------"

if [[ -n "$nameofmachine" ]]; then
hostnamectl hostname "$nameofmachine"
fi

pacman -Sy

ALL_PAKGS=('mkinitcpio' 'grub' 'efibootmgr' 'dhcpcd' 'networkmanager' 'openssh' 'git' 'vim' 'ntfs-3g' 'base' 'base-devel' 'linux' 'linux-firmware' 'python-pip' 'lvm2')

ALL_PAKGS+=('base' 'base-devel' 'linux' 'linux-firmware' 'linux-headers' 'zip' 'unzip' 'pigz' 'wget' 'ntfs-3g' 'dhcpcd' 'networkmanager' 'dhclient' 'ufw' 'p7zip' 'unrar' 'unarchiver' 'lzop' 'lrzip' 'curl')

ALL_PAKGS+=('bash-completion' 'python-pip' 'python-packaging' 'vim' 'rclone' 'git' 'fuse' 'fuse2' 'fuse3')

ALL_PAKGS+=('jdk11-openjdk' 'java-atk-wrapper-openjdk11' 'openjdk11-doc' 'openjdk11-src' 'maven' 'groovy' 'groovy-docs' 'gradle' 'gradle-src' 'gradle-doc' 'go' 'docker' 'criu' 'docker-scan')

ALL_PAKGS+=('xorg' 'xorg-xinit' 'phonon-qt5-gstreamer' 'plasma' 'plasma-meta' 'spectacle' 'sonnet' 'hunspell' 'hunspell-en_us' 'hunspell-en_gb' 'cryfs' 'encfs' 'gocryptfs' 'xdg-desktop-portal' 'gwenview' 'gnu-free-fonts' 'wireplumber' 'sddm')

ALL_PAKGS+=('kwallet-pam' 'kwalletmanager' 'kleopatra' 'partitionmanager' 'skanlite')

ALL_PAKGS+=('terminator' 'konsole')

ALL_PAKGS+=('packagekit-qt5' 'qbittorrent' 'kdialog')

ALL_PAKGS+=('dolphin' 'dolphin-plugins' 'kompare' 'kdegraphics-thumbnailers' 'kimageformats' 'qt5-imageformats' 'kdesdk-thumbnailers' 'ffmpegthumbs' 'raw-thumbnailer' 'taglib' 'ark')

ALL_PAKGS+=('libavtp' 'lib32-alsa-plugins' 'lib32-jack' 'lib32-libavtp' 'lib32-libsamplerate' 'lib32-libpulse' 'lib32-speexdsp' 'lib32-glib2')

ALL_PAKGS+=('kvantum-qt5' 'kde-gtk-config' 'fig2dev' 'gvfs' 'pstoedit' 'python-lxml' 'python-numpy' 'scour' 'texlive-core' 'jasper' 'libwmf' 'libxml2' 'ghostscript' 'breeze-gtk' 'oxygen')

ALL_PAKGS+=('ttf-roboto' 'ttf-ubuntu-font-family' 'cantarell-fonts' 'gtk-engine-murrine' 'gtk-engines' 'qt5-declarative' 'qt5-x11extras' 'kdecoration' 'noto-fonts' 'noto-fonts-cjk' 'noto-fonts-emoji' 'noto-fonts-extra' 'powerline-fonts')

ALL_PAKGS+=('webkit2gtk' 'gnome-themes-standard' 'gnome-keyring' 'seahorse' 'libgnome-keyring' 'appmenu-gtk-module')

ALL_PAKGS+=('cups' 'cups-pdf' 'hplip' 'usbutils' 'ghostscript' 'gsfonts' 'xsane' 'imagescan' 'sane' 'apparmor' 'python-pyqt5' 'python-gobject' 'dbus-python')

ALL_PAKGS+=('gimp' 'neofetch' 'bpytop' 'htop' 'mlocate' 'discord' 'bitwarden' 'inetutils' 'net-tools')

ALL_PAKGS+=('ffmpegthumbnailer' 'gst-libav' 'gstreamer' 'gst-plugins-bad' 'gst-plugins-good' 'gst-plugins-ugly' 'gst-plugins-base' 'gst-plugin-pipewire' 'a52dec' 'faac' 'faad2' 'flac' 'jasper' 'lame' 'libdca' 'libdv' 'libmad' 'libmpeg2' 'libtheora' 'libvorbis' 'libxv' 'wavpack' 'x264' 'xvidcore' 'vlc' 'celluloid' 'kcodecs')

ALL_PAKGS+=('bridge-utils' 'qemu' 'dmidecode' 'libguestfs' 'dnsmasq' 'openbsd-netcat' 'edk2-ovmf' 'qemu-arch-extra' 'qemu-block-gluster' 'qemu-block-iscsi' 'qemu-block-rbd' 'samba' 'ebtables' 'virt-viewer' 'virt-manager' 'gnome-menus' 'dbus-broker' 'tk')

# Not Sure if this is needed
ALL_PAKGS+=('libva-mesa-driver' 'lib32-libva-mesa-driver' 'mesa-vdpau' 'lib32-mesa-vdpau' 'lib32-mesa' 'libva-vdpau-driver' 'libvdpau-va-gl' 'mesa-utils' 'lib32-libva-vdpau-driver')

echo "--------------------------------------------------"
echo "--determine processor type and install microcode--"
echo "--------------------------------------------------"
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
    GenuineIntel)
        print "Installing Intel microcode"
        ALL_PAKGS+=('intel-ucode' 'libvdpau-va-gl' 'lib32-vulkan-intel' 'vulkan-intel' 'libva-intel-driver' 'libva-utils')
        modprobe -r kvm_intel
        modprobe kvm_intel nested=1
        echo "options kvm-intel nested=1" | tee /etc/modprobe.d/kvm-intel.conf
        ;;
    AuthenticAMD)
        print "Installing AMD microcode"
        ALL_PAKGS+=('amd-ucode' 'xf86-video-amdgpu' 'amdvlk' 'lib32-amdvlk')
        modprobe -r kvm_amd
        modprobe kvm_amd nested=1
        echo "options kvm_amd nested=1" | tee /etc/modprobe.d/kvm-amd.conf
        ;;
esac    

echo "--------------------------------------------------"
echo "         Graphics Drivers find and install        "
echo "--------------------------------------------------"
if lspci | grep -E "NVIDIA|GeForce"; then

echo "-----------------------------------------------------------"
echo "  Setting Nvidia Drivers setup pacman hook and udev rules  "
echo "-----------------------------------------------------------"

ALL_PAKGS+=('nvidia' 'nvidia-utils' 'nvidia-settings' 'nvidia-prime' 'lib32-nvidia-utils' 'nvtop')

mkdir -p "/etc/pacman.d/hooks"
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
echo "Nvidia pacman hook installed /etc/pacman.d/hooks/nvidia.hook"
cat /etc/pacman.d/hooks/nvidia.hook

mkdir /etc/udev/rules.d/ -p
cat <<EOT > "/etc/udev/rules.d/99-nvidia.rules"
ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c0 -u"
EOT

echo "Nvidia pudev rule installed /etc/udev/rules.d/99-nvidia.rules"
cat /etc/udev/rules.d/99-nvidia.rules

elif lspci | grep -E "Radeon"; then

echo "-----------------------------------------------------------"
echo "                    Setting AMD Drivers                    "
echo "-----------------------------------------------------------"

ALL_PAKGS+=('xf86-video-amdgpu' 'amdvlk' 'lib32-amdvlk')

elif lspci | grep -E "Integrated Graphics Controller"; then

echo "-----------------------------------------------------------"
echo "                   Setting Intel Drivers                   "
echo "-----------------------------------------------------------"

ALL_PAKGS+=('libvdpau-va-gl' 'lib32-vulkan-intel' 'vulkan-intel' 'libva-intel-driver' 'libva-utils')

fi

case $pipewire_yes_no in
    [Yy]* ) ALL_PAKGS+=('wireplumber' 'pipewire' 'pipewire-pulse' 'pipewire-alsa' 'pipewire-jack' 'lib32-pipewire' 'lib32-pipewire-jack');;
    * ) ALL_PAKGS+=('pulseaudio' 'pulseaudio-alsa' 'pulseaudio-bluetooth' 'pulseaudio-equalizer' 'pulseaudio-jack' 'pulseaudio-lirc' 'pulseaudio-zeroconf')
esac

echo "--------------------------------------------------"
echo "         Installing Hell lot of packages          "
echo "--------------------------------------------------"

pacman -S --needed "${ALL_PAKGS[@]}"

echo "--------------------------------------------------"
echo "         Setting Root Password to \"root\"        "
echo "--------------------------------------------------"
getent group sudo || groupadd sudo
getent group wheel || groupadd wheel
echo -e "root\nroot" | passwd

echo "-----------------------------------------------------------------------"
echo "       Install Grub Boot-loader with UEFI in directory /boot/efi       "
echo "-----------------------------------------------------------------------"

if [[ -n "$install_grub" ]]; then
mkinitcpio -P
grub-install --target=x86_64-efi --bootloader-id=Archlinux --efi-directory=/boot/efi --root-directory=/ --recheck
grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "----------------------------------------------------------------------------------------------"
echo "       Setting userprofile bin and gpg_tty /etc/profile.d/10-makemyarch-sw-init-auto.sh       "
echo "----------------------------------------------------------------------------------------------"

cat <<EOT > "/etc/profile.d/10-makemyarch-sw-init-auto.sh"
export PATH=\$HOME/.local/bin:\$PATH:/usr/sbin
export GPG_TTY=\$(tty)
export EDITOR=vim
EOT
cat /etc/profile.d/10-makemyarch-sw-init-auto.sh

echo "-----------------------------------------------------------------------------------"
echo "       Setting Java and Maven Home /etc/profile.d/10-makemyarch-java-auto.sh       "
echo "-----------------------------------------------------------------------------------"

cat <<EOT > "/etc/profile.d/10-makemyarch-java-auto.sh"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export MAVEN_HOME=/opt/maven
export M2_HOME=/opt/maven
export GRADLE_HOME=/usr/share/java/gradle
EOT
cat /etc/profile.d/10-makemyarch-java-auto.sh

echo "------------------------------------------"
echo "       heil wheel group in sudoers        "
echo "------------------------------------------"

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
cat /etc/sudoers | grep wheel

echo "-------------------------------------------------------"
echo "             Install Yay and AUR Packages              "
echo "-------------------------------------------------------"

if ! command -v yay &> /dev/null
then
# Yay User
    id -u makemyarch_build_user &>/dev/null || useradd -s /bin/bash -m -d /home/makemyarch_build_user makemyarch_build_user
    echo "makemyarch_build_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/10-makemyarch_build_user
    BASEDIR=$(dirname "$0")
    sudo -H -u makemyarch_build_user bash -c "$BASEDIR/install_yay.sh"
fi

PKGS_AUR=('ttf-menlo-powerline-git' 'kde-thumbnailer-apk' 'resvg' 'sweet-gtk-theme-mars' 'kvantum-theme-sweet-mars' 'kvantum-theme-sweet-git' 'sweet-cursor-theme-git' 'sweet-theme-git' 'sweet-folders-icons-git' 'sweet-kde-git' 'sweet-kde-theme-mars-git' 'candy-icons-git' 'layan-kde-git' 'layan-gtk-theme-git' 'layan-cursor-theme-git' 'kvantum-theme-layan-git' 'tela-icon-theme' 'nordic-darker-standard-buttons-theme' 'nordic-darker-theme' 'kvantum-theme-nordic-git' 'sddm-nordic-theme-git' 'nordic-kde-git' 'nordic-theme-git' 'ttf-meslo' 'google-chrome' 'brave-bin' 'timeshift' 'visual-studio-code-bin' 'nordvpn' 'sublime-text-4')

PKG_AUR_JOIN=$(printf " %s" "${PKGS_AUR[@]}")
sudo -H -u makemyarch_build_user bash -c "yay -S --answerclean None --answerdiff None --noconfirm --needed ${PKG_AUR_JOIN}"

echo "--------------------------------------"
echo "       Create User and Groups         "
echo "--------------------------------------"

if [[ -n "$username" ]]; then
id -u $username &>/dev/null || useradd -s /bin/bash -G docker,wheel,libvirt,nordvpn -m -d /home/$username $username
echo -e "password\npassword" | passwd $username
fi

echo "-------------------------------------------------"
echo "       Settings libvirt group and socket         "
echo "-------------------------------------------------"

## Virtmanager
sed -i '/^#.*unix_sock_group/s/^#//' /etc/libvirt/libvirtd.conf
sed -i '/^#.*unix_sock_rw_perms/s/^#//' /etc/libvirt/libvirtd.conf
grep -i "unix_sock_group" /etc/libvirt/libvirtd.conf
grep -i "unix_sock_rw_perms" /etc/libvirt/libvirtd.conf

echo "--------------------------------------"
echo "       Enable Mandatory Services      "
echo "--------------------------------------"
MAN_SERVICES=('dhcpcd' 'NetworkManager' 'sshd' 'systemd-timesyncd' 'systemd-resolved' 'iptables' 'ufw' 'docker' 'sddm' 'dbus-broker' 'libvirtd' 'nordvpnd' 'cups' 'apparmor' 'bluetooth') 

for MAN_SERVICE in "${MAN_SERVICES[@]}"; do
    echo "Enable Service: ${MAN_SERVICE}"
    systemctl enable "$MAN_SERVICE"
done

echo "-----------------------------------------"
echo "       Setting SDDM Theme as Nordic      "
echo "-----------------------------------------"

echo -e "\nSetup SDDM Theme"
cat <<EOF > /etc/sddm.conf
[Theme]
Current=Nordic
EOF
cat /etc/sddm.conf
