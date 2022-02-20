#!/usr/bin/env bash
set -e
echo "Starting setup.sh"
read -r -p "Please name your machine, (Leave empty and press Enter to Skip*) : " nameofmachine
echo ""
echo ""
read -r -n1 -p "Enter \"Y\" to replace PulseAudio with Pipewire, [Current/Default selection is PulseAudio] (Press any other key to Skip*) : " pipewire_yes_no
echo ""
echo ""
read -r -n1 -p "Enter \"Y\" Install KDE, [Current/Default selection is Gnome] (Press any other key to Skip*) : " kde_yes_no
echo ""
echo ""
read -r -p "Please enter username, [default password: password], (Leave empty and press Enter to Skip*) :  " username
echo ""
echo ""
if [[ -d "/sys/firmware/efi" ]]; then
    read -r -n1 -p "Enter \"Y\" to install UEFI Grub in mounted Fat32 drive, (Press any other key to Skip*) : " install_grub_uefi
    echo ""
    if [[ $install_grub_uefi == "Y" || $install_grub_uefi == "y" ]]; then
        read -r -p "Enter EFI directory location, (Default /boot/efi*, press n to skip grub install) : " install_grub_efi_dir
        echo ""
        if [ -z "$install_grub_efi_dir" ]; then
            install_grub_efi_dir="/boot/efi"
        elif [[ "$install_grub_efi_dir" == "n" || "$install_grub_efi_dir" == "N" ]]; then
            unset install_grub_efi_dir
        fi
    fi
fi

read -r -n1 -p "Enter \"Y\" to enable \"nested virtualization\" in qemu kvm, (Press any other key to Skip*) : " kvm_nested
echo ""
read -r -n1 -p "Enter \"Y\" to skip AUR packages, [Skipping this will break userprofile/themes] (Press any other key to install AUR Packages*) : " aur_packages_install
echo ""

echo "--------------------------------------"
echo "--     Time zone : Asia/Kolkata     --"
echo "--------------------------------------"
rm -rf /etc/localtime
timedatectl set-timezone Asia/Kolkata
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
timedatectl set-ntp true
echo ""
echo ""
echo "Current date time : " "$(date)"
echo ""
echo ""

echo "--------------------------------------"
echo "--       Localization : UTF-8       --"
echo "--------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
localectl --no-ask-password set-keymap us
echo 'LANG=en_US.UTF-8' >/etc/locale.conf
echo ""
echo ""
localectl
echo ""
echo ""

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have $nc cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for $nc cores."
TOTALMEM=$(grep -i 'memtotal' /proc/meminfo | grep -o '[[:digit:]]*')
if [[ $TOTALMEM -gt 8000000 ]]; then
    sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
    echo "Changing the compression settings for $nc cores."
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
    touch /etc/hosts
    touch /etc/hostname
    hostnamectl hostname "$nameofmachine"
    echo "$nameofmachine" >/etc/hostname

    cat <<EOT >"/etc/hosts"
127.0.0.1   localhost
::1         localhost
127.0.1.1   $nameofmachine $nameofmachine.localdomain
EOT

fi

pacman -Sy archlinux-keyring --noconfirm

grep "keyserver hkp://keyserver.ubuntu.com" \
    /etc/pacman.d/gnupg/gpg.conf ||
    echo "keyserver hkp://keyserver.ubuntu.com" >>/etc/pacman.d/gnupg/gpg.conf

pacman -Syu --noconfirm

ALL_PAKGS=('mkinitcpio' 'grub' 'efibootmgr' 'dhcpcd' 'networkmanager'
    'openssh' 'git' 'vim' 'ntfs-3g' 'base' 'base-devel' 'linux' 'linux-firmware' 'python-pip' 'lvm2')

ALL_PAKGS+=('base' 'base-devel' 'linux' 'linux-firmware' 'linux-headers' 'zip' 'unzip' 'pigz' 'wget' 'ntfs-3g'
    'dhcpcd' 'networkmanager' 'dhclient' 'ufw' 'p7zip' 'unrar' 'unarchiver' 'lzop' 'lrzip' 'curl')

ALL_PAKGS+=('bash-completion' 'python-pip' 'python-packaging' 'rclone' 'git' 'fuse' 'fuse2' 'fuse3')

ALL_PAKGS+=('xclip' 'xsel' 'wl-clipboard')

ALL_PAKGS+=('docker' 'criu' 'docker-scan')

ALL_PAKGS+=('lm_sensors')

if [[ "$kde_yes_no" == "Y" || "$kde_yes_no" == "y" ]]; then

    ALL_PAKGS+=('xorg' 'xorg-xinit' 'phonon-qt5-gstreamer' 'plasma' 'plasma-meta' 'spectacle' 'sonnet'
        'hunspell' 'hunspell-en_us' 'hunspell-en_gb' 'cryfs' 'encfs'
        'gocryptfs' 'xdg-desktop-portal' 'gwenview' 'gnu-free-fonts' 'wireplumber' 'sddm' 'konsole')

    ALL_PAKGS+=('kwallet-pam' 'kwalletmanager' 'kleopatra' 'partitionmanager' 'skanlite')

    ALL_PAKGS+=('packagekit-qt5' 'qbittorrent' 'kdialog')

    ALL_PAKGS+=('dolphin' 'dolphin-plugins' 'kompare' 'kdegraphics-thumbnailers' 'kimageformats'
        'qt5-imageformats' 'kdesdk-thumbnailers' 'ffmpegthumbs' 'raw-thumbnailer' 'taglib' 'ark')

    ALL_PAKGS+=('kvantum-qt5' 'kde-gtk-config' 'fig2dev' 'gvfs' 'pstoedit' 'python-lxml' 'python-numpy'
        'scour' 'texlive-core' 'jasper' 'libwmf' 'libxml2' 'ghostscript' 'breeze-gtk' 'oxygen')

    ALL_PAKGS+=('gtk-engine-murrine' 'gtk-engines' 'qt5-declarative' 'qt5-x11extras' 'kdecoration' 'print-manager')

    ALL_PAKGS+=('networkmanager-openvpn' 'libnma')

else

    ALL_PAKGS+=('xorg' 'xorg-server' 'xorg-xinit' 'gnome-shell' 'nautilus' 'gnome-terminal' 'gnome-tweak-tool' 'fprintd'
        'gnome-control-center' 'xdg-user-dirs' 'gdm' 'gnome-keyring' 'dialog')
    ALL_PAKGS+=('eog-plugins' 'gnome-calendar' 'gnome-calculator' 'gnome-clocks' 'gnome-contacts' 'cheese'
        'gnome-bluetooth' 'gnome-applets' 'totem' 'gnome-backgrounds' 'gnome-nettool'
        'libgtop' 'gnome-icon-theme-symbolic' 'gnome-icon-theme' 'dconf' 'gnome-system-monitor'
    )
    ALL_PAKGS+=('gvfs' 'gvfs-afc' 'gvfs-goa' 'gvfs-google' 'gvfs-gphoto2' 'gvfs-mtp' 'gvfs-nfs' 'gvfs-smb')
    ALL_PAKGS+=('libappindicator-gtk3' 'libappindicator-gtk2')

    ALL_PAKGS+=('gnome-sound-recorder')

    ALL_PAKGS+=('networkmanager-openvpn' 'libnma')

    ALL_PAKGS+=('webkit2gtk' 'gnome-themes-standard' 'gnome-keyring' 'seahorse' 'libgnome-keyring' 'appmenu-gtk-module')

fi

ALL_PAKGS+=('terminator' 'zsh')

ALL_PAKGS+=('libavtp' 'lib32-alsa-plugins' 'lib32-libavtp' 'lib32-libsamplerate' 'lib32-speexdsp' 'lib32-glib2')

ALL_PAKGS+=('thunderbird' 'libotr')

ALL_PAKGS+=('cups' 'cups-pdf' 'hplip' 'usbutils' 'ghostscript' 'gsfonts' 'xsane' 'imagescan'
    'sane' 'apparmor' 'python-pyqt5' 'python-gobject'
    'dbus-python' 'system-config-printer' 'python-pysmbc' 'cups-pk-helper')

ALL_PAKGS+=('gimp' 'neofetch' 'bpytop' 'htop' 'mlocate' 'discord' 'inetutils' 'net-tools'
    'sysstat' 'bashtop' 'gnuplot' 'webkit2gtk')

ALL_PAKGS+=('ffmpegthumbnailer' 'gst-libav' 'gstreamer' 'gst-plugins-bad'
    'gst-plugins-good' 'gst-plugins-ugly' 'gst-plugins-base' 'a52dec'
    'faac' 'faad2' 'flac' 'jasper' 'lame' 'libdca' 'libdv' 'libmad' 'ffmpeg' 'ffmpeg2theora'
    'libmpeg2' 'libtheora' 'libvorbis' 'libxv' 'wavpack' 'x264' 'xvidcore' 'vlc' 'kcodecs')

# gnome-menus might require for qemu
ALL_PAKGS+=('bridge-utils' 'qemu' 'dmidecode' 'libguestfs' 'dnsmasq' 'openbsd-netcat' 'edk2-ovmf'
    'qemu-arch-extra' 'qemu-block-gluster' 'qemu-block-iscsi'
    'qemu-block-rbd' 'samba' 'ebtables' 'virt-viewer'
    'virt-manager' 'dbus-broker' 'tk' 'swtpm')

# Not Sure if this is needed
ALL_PAKGS+=('libva-mesa-driver' 'lib32-libva-mesa-driver' 'mesa-vdpau'
    'lib32-mesa-vdpau' 'lib32-mesa' 'libva-vdpau-driver'
    'libvdpau-va-gl' 'mesa-utils' 'lib32-libva-vdpau-driver')

MAN_SERVICES=('dhcpcd' 'NetworkManager' 'sshd' 'systemd-timesyncd'
    'systemd-resolved' 'iptables' 'ufw' 'docker' 'dbus-broker'
    'libvirtd' 'cups' 'apparmor' 'bluetooth')

if [[ "$kde_yes_no" == "Y" || "$kde_yes_no" == "y" ]]; then

    MAN_SERVICES+=('sddm')

else

    MAN_SERVICES+=('gdm')

fi

echo "--------------------------------------------------"
echo "--determine processor type and install microcode--"
echo "--------------------------------------------------"
proc_type=$(grep vendor /proc/cpuinfo | uniq | awk '{print $3}')
echo "proc_type: $proc_type"
case "$proc_type" in
GenuineIntel)
    echo "Installing Intel microcode"
    ALL_PAKGS+=('intel-ucode' 'libvdpau-va-gl' 'lib32-vulkan-intel' 'vulkan-intel' 'libva-intel-driver' 'libva-utils')
    ;;
AuthenticAMD)
    echo "Installing AMD microcode"
    ALL_PAKGS+=('amd-ucode' 'xf86-video-amdgpu' 'amdvlk' 'lib32-amdvlk')
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

    echo ""
    echo "Packages to be installed: 'nvidia' 'nvidia-utils' 'nvidia-settings' 'nvidia-prime' 'lib32-nvidia-utils' 'nvtop'"
    echo ""

    mkdir -p "/etc/pacman.d/hooks"
    cat <<EOT >"/etc/pacman.d/hooks/nvidia.hook"
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
Exec=/bin/sh -c 'while read -r -r trg; do case \$trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOT
    echo "Nvidia pacman hook installed /etc/pacman.d/hooks/nvidia.hook"
    cat /etc/pacman.d/hooks/nvidia.hook

    mkdir /etc/udev/rules.d/ -p
    cat <<EOT >"/etc/udev/rules.d/99-nvidia.rules"
ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c0 -u"
EOT

    echo "Nvidia pudev rule installed /etc/udev/rules.d/99-nvidia.rules"
    cat /etc/udev/rules.d/99-nvidia.rules

fi

if lspci | grep -E "Radeon|Advanced Micro Devices"; then

    echo "-----------------------------------------------------------"
    echo "                    Setting AMD Drivers                    "
    echo "-----------------------------------------------------------"

    ALL_PAKGS+=('xf86-video-amdgpu' 'amdvlk' 'lib32-amdvlk')

    echo ""
    echo "Packages to be installed: 'xf86-video-amdgpu' 'amdvlk' 'lib32-amdvlk'"
    echo ""

fi

if lspci | grep -E "Integrated Graphics Controller"; then

    echo "-----------------------------------------------------------"
    echo "                   Setting Intel Drivers                   "
    echo "-----------------------------------------------------------"

    ALL_PAKGS+=('libvdpau-va-gl' 'lib32-vulkan-intel' 'vulkan-intel' 'libva-intel-driver' 'libva-utils')

    echo ""
    echo "Packages to be installed: 'libvdpau-va-gl' 'lib32-vulkan-intel' 'vulkan-intel' 'libva-intel-driver' 'libva-utils'"
    echo ""

fi

if lspci | grep -E "VMware SVGA"; then

    echo "-----------------------------------------------------------"
    echo "                   Setting VMware Drivers                   "
    echo "-----------------------------------------------------------"

    ALL_PAKGS+=('open-vm-tools' 'gtkmm3' 'xf86-input-vmmouse' 'xf86-video-vmware' 'mesa')

    MAN_SERVICES+=('vmtoolsd' 'vmware-vmblock-fuse')

    echo ""
    echo "Packages to be installed: 'open-vm-tools' 'gtkmm3'"
    echo "Services to be enabled: 'vmtoolsd' 'vmware-vmblock-fuse'"
    echo ""

fi

# Pipewire or Pulseaudio selection
if [[ "$pipewire_yes_no" == "Y" || "$pipewire_yes_no" == "y" ]]; then
    ALL_PAKGS+=('wireplumber' 'pipewire' 'pipewire-pulse' 'pipewire-alsa'
        'pipewire-jack' 'lib32-pipewire' 'lib32-pipewire-jack'
        'gst-plugin-pipewire' 'pipewire-v4l2' 'pipewire-zeroconf' 'lib32-pipewire-v4l2')
else
    ALL_PAKGS+=('pulseaudio' 'pulseaudio-alsa' 'pulseaudio-bluetooth'
        'lib32-libpulse' 'pulseaudio-equalizer' 'pulseaudio-jack'
        'pulseaudio-lirc' 'pulseaudio-zeroconf')
fi

echo "--------------------------------------------------"
echo "         Installing Hell lot of packages          "
echo "--------------------------------------------------"

pacman -S --needed --noconfirm "${ALL_PAKGS[@]}"

echo "--------------------------------------------------"
echo "         Setting Root Password to \"root\"        "
echo "--------------------------------------------------"
getent group sudo || groupadd sudo
getent group wheel || groupadd wheel
echo -e "root\nroot" | passwd

if [[ $install_grub_uefi == "Y" || $install_grub_uefi == "y" ]] && [ -n "$install_grub_efi_dir" ]; then
    echo "-----------------------------------------------------------------------------------"
    echo "       Install Grub Boot-loader with UEFI in directory $install_grub_efi_dir       "
    echo "-----------------------------------------------------------------------------------"
    mkinitcpio -P
    grub-install --target=x86_64-efi --bootloader-id=Archlinux \
        --efi-directory=${install_grub_efi_dir} --root-directory=/ --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "------------------------------------------"
echo "       heil wheel group in sudoers        "
echo "------------------------------------------"

# Add wheel no password rights
sed -i 's/^#.*wheel.*ALL.*NOPASSWD.*ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
grep wheel /etc/sudoers

echo "-------------------------------------------------------"
echo "             Install Yay and AUR Packages              "
echo "-------------------------------------------------------"

echo " Adding user makemyarch_build_user"
id -u makemyarch_build_user &>/dev/null ||
    useradd -s /bin/bash -m -d /home/makemyarch_build_user makemyarch_build_user
echo "makemyarch_build_user ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers.d/10-makemyarch_build_user

if ! command -v yay &>/dev/null; then
    # Yay User
    BASEDIR=$(dirname "$0")
    sudo -H -u makemyarch_build_user bash -c "$BASEDIR/install_yay.sh"
fi

PKGS_AUR=('google-chrome' 'brave-bin' 'timeshift' 'sublime-text-4')

if [[ "$kde_yes_no" == "Y" || "$kde_yes_no" == "y" ]]; then

    echo "No AUR Packages for KDE"

else

    PKGS_AUR+=('chrome-gnome-shell')

fi

PKG_AUR_JOIN=$(printf " %s" "${PKGS_AUR[@]}")

if [[ $aur_packages_install == "Y" || $aur_packages_install == "y" ]]; then
    echo "Skipping AUR Packages Install"
else
    sudo -H -u makemyarch_build_user bash -c "cd ~ && \
        yay -S --answerclean None --answerdiff None --noconfirm --needed ${PKG_AUR_JOIN}"
fi

echo "--------------------------------------"
echo "       Create User and Groups         "
echo "--------------------------------------"

if [[ -n "$username" ]]; then
    id -u "$username" &>/dev/null || useradd -s /bin/bash -G docker,wheel,libvirt -m -d "/home/$username" "$username"
    echo -e "password\npassword" | passwd "$username"
    BASEDIR=$(dirname "$0")

fi

echo "-----------------------------------------------------------------------"
echo "       Settings libvirt nested virtualization group and socket         "
echo "-----------------------------------------------------------------------"

## libvirt
sed -i '/^#.*unix_sock_group/s/^#//' /etc/libvirt/libvirtd.conf
sed -i '/^#.*unix_sock_rw_perms/s/^#//' /etc/libvirt/libvirtd.conf
grep -i "unix_sock_group" /etc/libvirt/libvirtd.conf
grep -i "unix_sock_rw_perms" /etc/libvirt/libvirtd.conf

if [[ $kvm_nested == "Y" || $kvm_nested == "y" ]]; then
    case "$proc_type" in
    GenuineIntel)
        echo "Enable Intel nested virtualization"
        modprobe -r kvm_intel
        modprobe kvm_intel nested=1
        mkdir -p /etc/modprobe.d
        echo "options kvm-intel nested=1" | tee /etc/modprobe.d/kvm-intel.conf
        echo "systool -m kvm_intel -v | grep nested"
        systool -m kvm_intel -v | grep nested
        echo "cat /sys/module/kvm_intel/parameters/nested"
        cat /sys/module/kvm_intel/parameters/nested
        ;;
    AuthenticAMD)
        echo "Enable AMD nested virtualization"
        modprobe -r kvm_amd
        modprobe kvm_amd nested=1
        mkdir -p /etc/modprobe.d
        echo "options kvm_amd nested=1" | tee /etc/modprobe.d/kvm-amd.conf
        echo "systool -m kvm_amd -v | grep -i nested"
        systool -m kvm_amd -v | grep -i nested
        echo "cat /sys/module/kvm_amd/parameters/nested"
        cat /sys/module/kvm_amd/parameters/nested
        ;;
    esac
fi

echo "--------------------------------------"
echo "       Enable Mandatory Services      "
echo "--------------------------------------"

for MAN_SERVICE in "${MAN_SERVICES[@]}"; do
    echo "Enable Service: ${MAN_SERVICE}"
    systemctl enable "$MAN_SERVICE"
done

echo "Completed"
echo 'Its a good idea to run pacman -R $(pacman -Qtdq) or yay -R $(yay -Qtdq)'
