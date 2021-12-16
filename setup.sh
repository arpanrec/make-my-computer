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

pacman -Sy --noconfirm

PAKGS=(
'pacman-contrib'
'curl'
'reflector'
'rsync'
'grub'
'efibootmgr'
'dhcpcd'
'networkmanager'
'openssh'
'git'
'vim'
'base'
'base-devel'
'linux'
'linux-firmware'
'python-pip'
'lvm2'
'linux-headers'
'unzip'
'zip'
'pigz'
'wget'
'ntfs-3g'
'dhclient'
'ufw'
'docker'
)

#
# determine processor type and install microcode
# 
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

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    PAKGS+=('nvidia')
elif lspci | grep -E "Radeon"; then
    PAKGS+=('xf86-video-amdgpu')
elif lspci | grep -E "Integrated Graphics Controller"; then
    PAKGS+=('libvdpau-va-gl' 'lib32-vulkan-intel' 'vulkan-intel' 'libva-intel-driver' 'libva-utils')
fi

pacman -S --noconfirm --needed "${PAKGS[@]}"

getent group sudo || groupadd sudo
getent group wheel || groupadd wheel
echo -e "root\nroot" | passwd

mkinitcpio -P

systemctl enable --now dhcpcd
systemctl enable --now NetworkManager
systemctl enable --now sshd
systemctl enable --now systemd-timesyncd
systemctl enable --now systemd-resolved
systemctl enable --now iptables
systemctl enable --now ufw

grub-install --target=x86_64-efi --bootloader-id=Archlinux --efi-directory=/boot/efi --root-directory=/ --recheck

grub-mkconfig -o /boot/grub/grub.cfg
