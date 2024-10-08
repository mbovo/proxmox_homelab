#!/bin/bash

echo 'Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = https://archmirror.it/repos/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist


pacman -Sy
pacman -S --noconfirm git python3 python-pip python-setuptools
pip uninstall -y archinstall
git clone https://github.com/archlinux/archinstall
cd archinstall
git checkout v2.3.3
python setup.py install

cd ..

cat <<EOF > config.json
{
    "audio": "none",
    "bootloader": "grub-install",
    "harddrives": ["/dev/sda"],
    "hostname": "node100",
    "kernels": [
        "linux"
    ],
    "keyboard-layout": "it",
    "mirror-region": {
        "Worldwide": {
            "https://mirror.rackspace.com/archlinux/\$repo/os/\$arch": true
        }
    },
    "nic": {
        "NetworkManager": true,
        "nic": "Use NetworkManager (necessary to configure internet graphically in GNOME and KDE)"
    },
    "ntp": true,
    "packages": [
        "crictl",
        "cri-o",
        "cni-plugins",
        "runc",
        "openssh",
        "wget",
        "nano",
        "git",
        "sudo",
        "cloud-init",
        "cloud-guest-utils",
        "qemu-guest-agent"
    ],
    "services": [
      "crio",
      "sshd",
      "cloud-init-local",
      "cloud-init",
      "cloud-config",
      "cloud-final",
      "qemu-guest-agent"
    ],
    "profile": "minimal",
    "swap": false,
    "sys-encoding": "utf-8",
    "sys-language": "en_US",
    "timezone": "Europe/Rome",
    "version": "2.3.3",
    "custom-commands": [
        "yes $'yes\nyes' | pacman --needed -S iptables-nft",
        "pacman -S --noconfirm kubelet kubectl kubeadm"
    ]
}
EOF

cat <<EOF > disks.json
{
    "/dev/sda": {
        "partitions": [
            {
                "boot": true,
                "encrypted": false,
                "filesystem": {
                    "format": "fat32"
                },
                "format": true,
                "mountpoint": "/boot",
                "size": "513MB",
                "start": "5MB",
                "type": "primary"
            },
            {
                "btrfs": {
                    "subvolumes": {
                        "@": "/",
                        "@.snapshots": "/.snapshots",
                        "@home": "/home",
                        "@log": "/var/log",
                        "@pkgs": "/var/cache/pacman/pkg"
                    }
                },
                "encrypted": false,
                "filesystem": {
                    "format": "btrfs"
                },
                "format": true,
                "mountpoint": "/",
                "size": "100%",
                "start": "518MB",
                "type": "primary"
            }
        ],
        "wipe": true
    }
}
EOF

cat <<EOF > creds.json
{
  "!root-password": "password"
}
EOF

sleep 5

archinstall --config ./config.json --creds ./creds.json --disk_layouts ./disks.json --silent
sleep 5

export NEWUSER="arch"
export MOUNT="/mnt/archinstall"
arch-chroot "${MOUNT}" /usr/bin/useradd -m -U "${NEWUSER}"
echo -e "${NEWUSER}\n${NEWUSER}" | arch-chroot "${MOUNT}" /usr/bin/passwd "${NEWUSER}"
echo "${NEWUSER} ALL=(ALL) NOPASSWD: ALL" >"${MOUNT}/etc/sudoers.d/${NEWUSER}"


