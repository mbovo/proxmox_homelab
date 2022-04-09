variable "username" {
  type    = string
  default = "invalid-user"
}

variable "token" {
  type      = string
  sensitive = true
  default   = "invalid-token"
}

variable "sshkey" {
  type      = string
  sensitive = false
  default   = "invalid-key"
}

packer {
  required_plugins {
    proxmox = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox" "arch" {

  proxmox_url              = "https://cube.i.zroot.org:8006/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.username
  token                    = var.token
  node                     = "cube"
  iso_file                 = "local-btrfs:iso/archlinux-2022.03.1-x86_64.iso"

  cores  = 2
  memory = 4096

  vm_name = "kubetemplate"

  unmount_iso = true

  ssh_username = "root"
  ssh_password = "pi"

  network_adapters {
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = true
  }

  disks {
    type              = "scsi"
    disk_size         = "32G"
    storage_pool      = "local-btrfs"
    format            = "raw"
    storage_pool_type = "btrfs"
  }

  boot_command = [
    "<enter><wait70s>",
    "passwd<enter><wait2s>",
    "pi<enter><wait2s>",
    "pi<enter><wait5s><enter>",
  ]

}

build {
  sources = ["source.proxmox.arch"]

  provisioner "shell" {
    script = "packer/scripts/setup.sh"
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /mnt/archinstall/root/.ssh; echo '${var.sshkey}' > /mnt/archinstall/root/.ssh/authorized_keys"
    ]
  }
}
