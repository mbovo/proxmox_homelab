[Unit]
Description=Pixicore service

[Service]
ExecStart=/usr/bin/pixiecore boot --bootmsg "Booting Talos Linux" /root/vmlinuz-amd64 /root/initramfs-amd64.xz -d --cmdline 'init_on_alloc=1 slab_nomerge pti=on panic=0 consoleblank=0 printk.devkmsg=on earlyprintk=ttyS0 console=tty0 console=ttyS0 talos.platform=metal'

[Install]
WantedBy=multi-user.target