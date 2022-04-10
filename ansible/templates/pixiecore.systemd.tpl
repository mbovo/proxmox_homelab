[Unit]
Description=Pixicore service

[Service]
ExecStart=/usr/bin/pixiecore boot --bootmsg "Booting Talos Linux" /root/vmlinuz-amd64 /root/initramfs-amd64.xz -d

[Install]
WantedBy=multi-user.target