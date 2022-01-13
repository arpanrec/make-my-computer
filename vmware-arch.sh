#!/usr/bin/env bash
pacman -S --needed --noconfirm fuse2 gtkmm linux-headers ncurses libcanberra pcsclite
mkdir /etc/init.d/ /tmp/nebula -p
if [ ! -f "/tmp/nebula/vmware.bundle" ]; then
  wget --no-clobber --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" --no-check-certificate -O /tmp/nebula/vmware.bundle https://www.vmware.com/go/getWorkstation-linux
  # rm -rf /tmp/nebula/vmware.bundle
fi
chmod +x /tmp/nebula/vmware.bundle
/bin/sh /tmp/nebula/vmware.bundle

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
modprobe -a vmw_vmci vmmon
