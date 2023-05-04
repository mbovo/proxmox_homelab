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

  proxmox_url              = "https://p3.i.zroot.org:8006/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.username
  token                    = var.token
  node                     = "p3"
  iso_file                 = "local:iso/archlinux-2023.02.01-x86_64.iso"

  cores  = 2
  memory = 4096

  vm_name = "kubetemplate"

  unmount_iso = true

  ssh_username = "root"
  ssh_password = "pi"

  cloud_init              = true
  cloud_init_storage_pool = "data"

  network_adapters {
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = true
    vlan_tag = 1212
  }

  disks {
    type              = "scsi"
    disk_size         = "32G"
    storage_pool      = "data"
    format            = "raw"
    storage_pool_type = "lvm-thin"
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
    script = "low/packer/scripts/setup.sh"
  }

  # provisioner "shell" {
  #   inline = [
  #     "mkdir -p /mnt/archinstall/root/.ssh; echo '${var.sshkey}' > /mnt/archinstall/root/.ssh/authorized_keys"
  #   ]
  # }
}
