#!/usr/bin/env bash
set -e

pacman -S --needed --noconfirm dkms fuse2 gtkmm3 gtkmm libaio linux-headers ncurses libcanberra pcsclite hicolor-icon-theme gtk3 gcr

tmp_vmware_dir=/tmp/vmware_install_make_my_computer

mkdir /etc/init.d/ $tmp_vmware_dir -p
if [ ! -f "$tmp_vmware_dir/vmware.bundle" ]; then
  wget --no-clobber --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" --no-check-certificate -O $tmp_vmware_dir/vmware.bundle https://www.vmware.com/go/getWorkstation-linux
  # rm -rf $tmp_vmware_dir/vmware.bundle
fi

chmod +x $tmp_vmware_dir/vmware.bundle
/bin/sh $tmp_vmware_dir/vmware.bundle

vmware_version_installed=$(vmware --version | awk '{ print $3 }')
current_kernel_version=$(uname -r | awk -F . '{print $1 "." $2}')

if [ ! -f "$tmp_vmware_dir/w$vmware_version_installed-k$current_kernel_version.tar.gz" ]; then
    wget "https://github.com/mkubecek/vmware-host-modules/archive/refs/tags/w$vmware_version_installed-k$current_kernel_version.tar.gz" \
                -O "$tmp_vmware_dir/w$vmware_version_installed-k$current_kernel_version.tar.gz"
fi

mkdir -p "$tmp_vmware_dir/vmware-host-modules-w$vmware_version_installed-k$current_kernel_version"

if [ ! "$(ls -A $tmp_vmware_dir/vmware-host-modules-w"$vmware_version_installed"-k"$current_kernel_version")" ]; then
  tar -zxvf "$tmp_vmware_dir/w$vmware_version_installed-k$current_kernel_version.tar.gz" -C "$tmp_vmware_dir/"
fi

cd "$tmp_vmware_dir/vmware-host-modules-w$vmware_version_installed-k$current_kernel_version"

tar -cf vmmon.tar vmmon-only
tar -cf vmnet.tar vmnet-only

cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source/

vmware-modconfig --console --install-all
modprobe -a vmw_vmci vmmon

cat <<EOT > "/etc/systemd/system/vmware.service"
[Unit]
Description=VMware daemon
Requires=vmware-usbarbitrator.service
Before=vmware-usbarbitrator.service
After=network.target

[Service]
ExecStart=/etc/init.d/vmware start
ExecStop=/etc/init.d/vmware stop
PIDFile=/var/lock/subsys/vmware
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT

cat <<EOT > "/etc/systemd/system/vmware-usbarbitrator.service"
[Unit]
Description=VMware USB Arbitrator
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/usr/bin/vmware-usbarbitrator
ExecStop=/usr/bin/vmware-usbarbitrator --kill
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT

cat <<EOT > "/etc/systemd/system/vmware-networks-server.service"
[Unit]
Description=VMware Networks
Wants=vmware-networks-configuration.service
After=vmware-networks-configuration.service

[Service]
Type=forking
ExecStartPre=-/sbin/modprobe vmnet
ExecStart=/usr/bin/vmware-networks --start
ExecStop=/usr/bin/vmware-networks --stop

[Install]
WantedBy=multi-user.target
EOT

cat <<EOT > "/etc/systemd/system/vmware-workstation-server.service"
[Unit]
Description=VMware Workstation Server
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/etc/init.d/vmware-workstation-server start
ExecStop=/etc/init.d/vmware-workstation-server stop
PIDFile=/var/lock/subsys/vmware-workstation-server
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload

echo "VMWare workstation install complete"
