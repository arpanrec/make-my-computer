#!/usr/bin/env bash
set -e
read -p "Please name your machine, Leave empty inorder to skip: " nameofmachine
read -p "Do you want pipewire? [Default PulseAudio] (Y for pipewire, Any other key to install pulseaudio) : " pipewire_yes_no
read -p "Please enter username: leave empty to skip:  " username
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

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

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

ALL_PAKGS=('alsa-plugins' 'alsa-utils' 'appmenu-gtk-module' 'ark' 'audiocd-kio' 'autoconf' 'automake' 'base' 'base-devel' 'bash-completion' 'bind' 'binutils' 'bison' 'bluedevil' 'bluez' 'bluez-libs' 'bluez-utils' 'breeze' 'breeze-gtk' 'bridge-utils' 'btrfs-progs' 'cantarell-fonts' 'celluloid' 'cmatrix' 'cronie' 'cryfs' 'cups' 'curl' 'dhclient' 'dhcpcd' 'dialog' 'discover' 'docker' 'dolphin' 'dolphin-plugins' 'dosfstools' 'dtc' 'efibootmgr' 'egl-wayland' 'encfs' 'exfat-utils' 'extra-cmake-modules' 'ffmpegthumbs' 'fig2dev' 'filelight' 'flex' 'fuse2' 'fuse3' 'fuseiso' 'gamemode' 'gcc' 'ghostscript' 'gimp' 'git' 'gnome-keyring' 'gocryptfs' 'gparted' 'gptfdisk' 'gradle' 'gradle-doc' 'gradle-src' 'groovy' 'grub' 'grub-customizer' 'gst-libav' 'gst-plugins-good' 'gst-plugins-ugly' 'gtk-engine-murrine' 'gtk-engines' 'gvfs' 'gwenview' 'haveged' 'htop' 'hunspell' 'hunspell-en_gb' 'hunspell-en_us' 'iptables-nft' 'jasper' 'jdk11-openjdk' 'kcodecs' 'kcoreaddons' 'kdecoration' 'kdegraphics-thumbnailers' 'kde-gtk-config' 'kdeplasma-addons' 'kdesdk-thumbnailers' 'kdialog' 'kimageformats' 'kinfocenter' 'kitty' 'kleopatra' 'kompare' 'konsole' 'kscreen' 'kvantum-qt5' 'kwalletmanager' 'kwallet-pam' 'layer-shell-qt' 'lib32-alsa-plugins' 'lib32-glib2' 'lib32-jack' 'lib32-libavtp' 'lib32-libpulse' 'lib32-libsamplerate' 'lib32-speexdsp' 'libavtp' 'libdvdcss' 'libgnome-keyring' 'libnewt' 'libtool' 'libwmf' 'libxml2' 'linux' 'linux-firmware' 'linux-headers' 'lsof' 'lutris' 'lvm2' 'lzop' 'm4' 'make' 'maven' 'mesa' 'milou' 'nano' 'neofetch' 'networkmanager' 'noto-fonts' 'noto-fonts-cjk' 'noto-fonts-emoji' 'noto-fonts-extra' 'ntfs-3g' 'ntp' 'okular' 'openbsd-netcat' 'openssh' 'os-prober' 'oxygen' 'p7zip' 'packagekit-qt5' 'pacman-contrib' 'partitionmanager' 'patch' 'phonon-qt5-gstreamer' 'picom' 'pigz' 'pkgconf' 'plasma' 'plasma-desktop' 'plasma-meta' 'plasma-nm' 'powerdevil' 'powerline-fonts' 'print-manager' 'pstoedit' 'python' 'python-lxml' 'python-notify2' 'python-numpy' 'python-packaging' 'python-pip' 'python-psutil' 'python-pyqt5' 'qbittorrent' 'qemu' 'qt5-declarative' 'qt5-imageformats' 'qt5-x11extras' 'raw-thumbnailer' 'rclone' 'reflector' 'rsync' 'scour' 'sddm' 'sddm-kcm' 'seahorse' 'skanlite' 'snapper' 'sonnet' 'spectacle' 'steam' 'sudo' 'swtpm' 'synergy' 'systemsettings' 'taglib' 'terminator' 'terminus-font' 'texlive-core' 'traceroute' 'ttf-roboto' 'ttf-ubuntu-font-family' 'ufw' 'unrar' 'unzip' 'usbutils' 'vim' 'virt-manager' 'virt-viewer' 'webkit2gtk' 'wget' 'which' 'wine-gecko' 'wine-mono' 'winetricks' 'xdg-desktop-portal' 'xdg-desktop-portal-kde' 'xdg-user-dirs' 'xorg' 'xorg-apps' 'xorg-drivers' 'xorg-server' 'xorg-xinit' 'xorg-xkill' 'xterm' 'zeroconf-ioslave' 'zip' 'ttf-droid' 'ttf-hack' 'ttf-roboto' 'ffmpegthumbnailer' 'gstreamer' 'gst-plugins-bad' 'gst-plugins-base' 'gst-plugin-pipewire' 'a52dec' 'faac' 'faad2' 'flac' 'lame' 'libdca' 'libdv' 'libmad' 'wavpack' 'vlc' 'libmpeg2' 'xvidcore' 'libtheora' 'libvorbis' 'libxv' 'x264' 'cups-pdf' 'hplip' 'gsfonts' 'xsane' 'imagescan' 'sane' 'apparmor' 'python-pyqt5' 'python-gobject' 'dbus-python' 'dmidecode' 'libguestfs' 'dnsmasq' 'edk2-ovmf' 'qemu-arch-extra' 'qemu-block-gluster' 'qemu-block-iscsi' 'qemu-block-rbd' 'samba' 'ebtables' 'gnome-menus' 'dbus-broker')

# Not Sure if this is needed
ALL_PAKGS+=('libva-mesa-driver' 'lib32-libva-mesa-driver' 'mesa-vdpau' 'lib32-mesa-vdpau' 'lib32-mesa' 'libva-vdpau-driver' 'libvdpau-va-gl' 'mesa-utils' 'lib32-libva-vdpau-driver')

echo "--------------------------------------------------"
echo "--determine processor type and install microcode--"
echo "--------------------------------------------------"
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
    GenuineIntel)
        print "Installing Intel microcode"
        ALL_PAKGS+=(intel-ucode)
        sudo modprobe -r kvm_intel
        sudo modprobe kvm_intel nested=1
        echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf
        ;;
    AuthenticAMD)
        print "Installing AMD microcode"
        ALL_PAKGS+=(amd-ucode)
        sudo modprobe -r kvm_amd
        sudo modprobe kvm_amd nested=1
        echo "options kvm_amd nested=1" | sudo tee /etc/modprobe.d/kvm-amd.conf
        ;;
esac    

echo "--------------------------------------------------"
echo "         Graphics Drivers find and install        "
echo "--------------------------------------------------"
if lspci | grep -E "NVIDIA|GeForce"; then
    ALL_PAKGS+=('nvidia' 'nvidia-utils' 'nvidia-settings' 'nvidia-prime' 'lib32-nvidia-utils' 'nvtop')
elif lspci | grep -E "Radeon"; then
    ALL_PAKGS+=('xf86-video-amdgpu' 'amdvlk' 'lib32-amdvlk')
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

case $pipewire_yes_no in
    [Yy]* ) ALL_PAKGS+=('wireplumber' 'pipewire' 'pipewire-pulse' 'pipewire-alsa' 'pipewire-jack' 'lib32-pipewire' 'lib32-pipewire-jack');;
    * ) ALL_PAKGS+=('pulseaudio' 'pulseaudio-alsa' 'pulseaudio-bluetooth' 'pulseaudio-equalizer' 'pulseaudio-jack' 'pulseaudio-lirc' 'pulseaudio-zeroconf')
esac

pacman -S --needed "${ALL_PAKGS[@]}"

echo "--------------------------------------"
echo "         Setting Root Password        "
echo "--------------------------------------"
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
echo "       Enable Mandatory Services      "
echo "--------------------------------------"
MAN_SERVICES=('dhcpcd' 'NetworkManager' 'sshd' 'systemd-timesyncd' 'systemd-resolved' 'iptables' 'ufw' 'docker' 'sddm' 'dbus-broker' 'libvirtd' 'nordvpnd') 

for MAN_SERVICE in "${MAN_SERVICES[@]}"; do
    echo "Enable Service: ${MAN_SERVICE}"
    systemctl enable "$MAN_SERVICE"
done

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

PKGS_AUR=('ttf-menlo-powerline-git' 'kde-thumbnailer-apk' 'resvg' 'sweet-gtk-theme-mars' 'kvantum-theme-sweet-mars' 'kvantum-theme-sweet-git' 'sweet-cursor-theme-git' 'sweet-theme-git' 'sweet-folders-icons-git' 'sweet-kde-git' 'sweet-kde-theme-mars-git' 'candy-icons-git' 'layan-kde-git' 'layan-gtk-theme-git' 'layan-cursor-theme-git' 'kvantum-theme-layan-git' 'tela-icon-theme' 'nordic-darker-standard-buttons-theme' 'nordic-darker-theme' 'kvantum-theme-nordic-git' 'sddm-nordic-theme-git' 'nordic-kde-git' 'nordic-theme-git' 'ttf-meslo' 'google-chrome' 'brave-bin' 'timeshift' 'visual-studio-code-bin' 'nordvpn')

PKG_AUR_JOIN=$(printf " %s" "${PKGS_AUR[@]}")
sudo -H -u nebula_build_user bash -c "yay -S --answerclean None --answerdiff None --noconfirm --needed ${PKG_AUR_JOIN}"

echo "--------------------------------------"
echo "       Create User and Groups         "
echo "--------------------------------------"

if [[ -n "$username" ]]; then
id -u $username &>/dev/null || useradd -s /bin/bash -G docker,wheel -m -d /home/$username $username
passwd $username
fi

## Virtmanager
sed -i '/^#.* unix_sock_group /s/^#//' /etc/libvirt/libvirtd.conf
sed -i '/^#.* unix_sock_rw_perms /s/^#//' /etc/libvirt/libvirtd.conf
