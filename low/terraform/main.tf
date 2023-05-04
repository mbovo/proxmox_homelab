# module "vm_pixie" {
#   source = "./modules/proxmox_vm"

#   proxmox_debug      = true
#   proxmox_log_enable = true
#   proxmox_api_url    = "https://p1.i.zroot.org:8006/api2/json"

#   vm = {
#     "pixie" = {
#       vmid        = 500
#       target_node = "p2"
#       template    = "archtemplate"
#       full_clone  = true
#       onboot      = true
#       network = [{
#         bridge   = "vmbr1"
#         model    = "virtio"
#         firewall = false
#       }]
#       disk = [{
#         type    = "scsi"
#         storage = "data"
#         size    = "32G"
#       }]
#       init = {
#         os_type      = "cloud-init"
#         user         = "arch"
#         password     = "arch"
#         ipconfig0    = "ip=10.20.20.59/24,gw=10.20.20.10"
#         nameserver   = "10.20.20.10"
#         searchdomain = "i.zroot.org"
#         sshkeys      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3kal9Z3mE2LLvVVKNCVpmpK0VECKP4P6y+R7qNgbEvKxeWiUs/Cayd2luDXF/r4k8QzqmvwNcTm8DJsrOyq5XKGSxXPcddbg8zXdo6yic6OmqvzNY5S3DtFE+VFJPOqZophlgKjI+11DwwIjtu4m5gh3sIwP9XEU3feidrqTNZBCEAfncj4NJ6frxRKG+OdFw7NqnQii6SIrJASPHQP/wihT0yqUSc9YlXc87SgbQm6JNf3PWescKEmIlIzK6Uw+J+iL91XRePL5xnVhSPPxpJ0evmAjKJJ8LqiRd3uSvGAJ54BDXa+gogmebpRg/M82on1fyHziN6VYHxO/joroh45rkqERw5LebOiuz0rM2gKWr56HM67Dzj9cOM6uZHE5Ej3W/TkkS2d5xyLV8m+Ou64WcAXxrwBic3zy+4L4zqkqs6qLyijPeLrF+bGdBogddtH9SMjg0wG+mqADUkzLqQBX1kWB8uBevzYyS8DtYzhNqInTyP3678sNg+gET9G0= manuel.bovo@mbkp.i.zroot.org"
#       }
#     }
#   }
# }

# resource "null_resource" "ansible_pixie" {
#   provisioner "local-exec" {

#     working_dir = "../ansible/"
#     command     = "sleep 120; ansible-playbook -i inventory ./playbooks/pixie.yaml"
#   }
#   depends_on = [module.vm_pixie]

# }

# module "vm_talos_masters" {
#   source = "./modules/proxmox_vm"

#   proxmox_debug      = true
#   proxmox_log_enable = true
#   proxmox_api_url    = "https://p1.i.zroot.org:8006/api2/json"

#   vm = {
#     "node1" = {
#       vmid        = 501
#       target_node = "cube"
#       pxe         = true
#       # network, cd-rom, hard disc
#       boot   = "ndc"
#       onboot = true
#       network = [{
#         bridge     = "vmbr1"
#         model      = "virtio"
#         firewall   = false
#         macaddress = "aa:aa:aa:aa:aa:61"
#       }]
#       init = {}
#       disk = [{
#         type    = "virtio"
#         storage = "local-btrfs"
#         size    = "4G"
#       }]
#     }
#   }
#   # },
#   # "node2" = {
#   #   vmid        = 502
#   #   target_node = "cube"
#   #   iso = "local-btrfs:iso/talos-amd64.iso"
#   #   full_clone  = true
#   #   onboot      = true
#   #   network = [{
#   #     bridge   = "vmbr1"
#   #     model    = "virtio"
#   #     firewall = false
#   #     macaddr = "aa:aa:aa:aa:aa:62"
#   #   }]
#   #   init = {}
#   #   disk = [{
#   #     type    = "virtio"
#   #     storage = "local-btrfs"
#   #     size    = "4G"
#   #   }]
#   # },
#   # "node3" = {
#   #   vmid        = 503
#   #   target_node = "cube"
#   #   iso = "local-btrfs:iso/talos-amd64.iso"
#   #   full_clone  = true
#   #   onboot      = true
#   #   network = [{
#   #     bridge   = "vmbr1"
#   #     model    = "virtio"
#   #     firewall = false
#   #     macaddr = "aa:aa:aa:aa:aa:63"
#   #   }]
#   #   init = {}
#   #   disk = [{
#   #     type    = "virtio"
#   #     storage = "local-btrfs"
#   #     size    = "4G"
#   #   }]
#   # }
# }


terraform {
  cloud {
    organization = "zroot"
    workspaces { name = "proxmox_templates" }
  }
  required_version = ">= 1.4.0"
}

module "vm_kubecp" {
  source = "./modules/proxmox_vm"

  proxmox_debug      = true
  proxmox_log_enable = true
  proxmox_api_url    = "https://p3.i.zroot.org:8006/api2/json"

  vm = {
    "m0" = {
      vmid        = 500
      target_node = "p3"
      template    = "kubetemplate"
      full_clone  = false
      onboot      = true
      cores       = 2
      memory      = 2048
      network = [{
        bridge   = "vmbr1"
        model    = "virtio"
        tag      = "1212"
        firewall = false
      }]
      disk = [{
        type    = "scsi"
        storage = "data"
        size    = "32G"
      }]
      init = {
        os_type          = "cloud-init"
        user             = "arch"
        password         = "arch"
        ipconfig0        = "ip=10.12.12.80/24,gw=10.12.12.10"
        nameserver       = "10.12.12.10"
        searchdomain     = "i.zroot.org"
        sshkeys          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3kal9Z3mE2LLvVVKNCVpmpK0VECKP4P6y+R7qNgbEvKxeWiUs/Cayd2luDXF/r4k8QzqmvwNcTm8DJsrOyq5XKGSxXPcddbg8zXdo6yic6OmqvzNY5S3DtFE+VFJPOqZophlgKjI+11DwwIjtu4m5gh3sIwP9XEU3feidrqTNZBCEAfncj4NJ6frxRKG+OdFw7NqnQii6SIrJASPHQP/wihT0yqUSc9YlXc87SgbQm6JNf3PWescKEmIlIzK6Uw+J+iL91XRePL5xnVhSPPxpJ0evmAjKJJ8LqiRd3uSvGAJ54BDXa+gogmebpRg/M82on1fyHziN6VYHxO/joroh45rkqERw5LebOiuz0rM2gKWr56HM67Dzj9cOM6uZHE5Ej3W/TkkS2d5xyLV8m+Ou64WcAXxrwBic3zy+4L4zqkqs6qLyijPeLrF+bGdBogddtH9SMjg0wG+mqADUkzLqQBX1kWB8uBevzYyS8DtYzhNqInTyP3678sNg+gET9G0= manuel.bovo@mbkp.i.zroot.org"
        automatic_reboot = true
      }
    },
    "m1" = {
      vmid        = 501
      target_node = "p3"
      template    = "kubetemplate"
      full_clone  = false
      onboot      = true
      cores       = 4
      memory      = 8192
      network = [{
        bridge   = "vmbr1"
        model    = "virtio"
        tag      = "1212"
        firewall = false
      }]
      disk = [{
        type    = "scsi"
        storage = "data"
        size    = "120G"
      }]
      init = {
        os_type          = "cloud-init"
        user             = "arch"
        password         = "arch"
        ipconfig0        = "ip=10.12.12.51/24,gw=10.12.12.10"
        nameserver       = "10.12.12.10"
        searchdomain     = "i.zroot.org"
        sshkeys          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3kal9Z3mE2LLvVVKNCVpmpK0VECKP4P6y+R7qNgbEvKxeWiUs/Cayd2luDXF/r4k8QzqmvwNcTm8DJsrOyq5XKGSxXPcddbg8zXdo6yic6OmqvzNY5S3DtFE+VFJPOqZophlgKjI+11DwwIjtu4m5gh3sIwP9XEU3feidrqTNZBCEAfncj4NJ6frxRKG+OdFw7NqnQii6SIrJASPHQP/wihT0yqUSc9YlXc87SgbQm6JNf3PWescKEmIlIzK6Uw+J+iL91XRePL5xnVhSPPxpJ0evmAjKJJ8LqiRd3uSvGAJ54BDXa+gogmebpRg/M82on1fyHziN6VYHxO/joroh45rkqERw5LebOiuz0rM2gKWr56HM67Dzj9cOM6uZHE5Ej3W/TkkS2d5xyLV8m+Ou64WcAXxrwBic3zy+4L4zqkqs6qLyijPeLrF+bGdBogddtH9SMjg0wG+mqADUkzLqQBX1kWB8uBevzYyS8DtYzhNqInTyP3678sNg+gET9G0= manuel.bovo@mbkp.i.zroot.org"
        automatic_reboot = true
      }
    },
    "m2" = {
      vmid        = 502
      target_node = "p3"
      template    = "kubetemplate"
      full_clone  = false
      onboot      = true
      cores       = 4
      memory      = 8192
      network = [{
        bridge   = "vmbr1"
        model    = "virtio"
        tag      = "1212"
        firewall = false
      }]
      disk = [{
        type    = "scsi"
        storage = "data"
        size    = "120G"
      }]
      init = {
        os_type          = "cloud-init"
        user             = "arch"
        password         = "arch"
        ipconfig0        = "ip=10.12.12.52/24,gw=10.12.12.10"
        nameserver       = "10.12.12.10"
        searchdomain     = "i.zroot.org"
        sshkeys          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3kal9Z3mE2LLvVVKNCVpmpK0VECKP4P6y+R7qNgbEvKxeWiUs/Cayd2luDXF/r4k8QzqmvwNcTm8DJsrOyq5XKGSxXPcddbg8zXdo6yic6OmqvzNY5S3DtFE+VFJPOqZophlgKjI+11DwwIjtu4m5gh3sIwP9XEU3feidrqTNZBCEAfncj4NJ6frxRKG+OdFw7NqnQii6SIrJASPHQP/wihT0yqUSc9YlXc87SgbQm6JNf3PWescKEmIlIzK6Uw+J+iL91XRePL5xnVhSPPxpJ0evmAjKJJ8LqiRd3uSvGAJ54BDXa+gogmebpRg/M82on1fyHziN6VYHxO/joroh45rkqERw5LebOiuz0rM2gKWr56HM67Dzj9cOM6uZHE5Ej3W/TkkS2d5xyLV8m+Ou64WcAXxrwBic3zy+4L4zqkqs6qLyijPeLrF+bGdBogddtH9SMjg0wG+mqADUkzLqQBX1kWB8uBevzYyS8DtYzhNqInTyP3678sNg+gET9G0= manuel.bovo@mbkp.i.zroot.org"
        automatic_reboot = true
      }
    },
    "m3" = {
      vmid        = 503
      target_node = "p3"
      template    = "kubetemplate"
      full_clone  = false
      onboot      = true
      cores       = 4
      memory      = 8192
      network = [{
        bridge   = "vmbr1"
        model    = "virtio"
        tag      = "1212"
        firewall = false
      }]
      disk = [{
        type    = "scsi"
        storage = "data"
        size    = "120G"
      }]
      init = {
        os_type          = "cloud-init"
        user             = "arch"
        password         = "arch"
        ipconfig0        = "ip=10.12.12.53/24,gw=10.12.12.10"
        nameserver       = "10.12.12.10"
        searchdomain     = "i.zroot.org"
        sshkeys          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3kal9Z3mE2LLvVVKNCVpmpK0VECKP4P6y+R7qNgbEvKxeWiUs/Cayd2luDXF/r4k8QzqmvwNcTm8DJsrOyq5XKGSxXPcddbg8zXdo6yic6OmqvzNY5S3DtFE+VFJPOqZophlgKjI+11DwwIjtu4m5gh3sIwP9XEU3feidrqTNZBCEAfncj4NJ6frxRKG+OdFw7NqnQii6SIrJASPHQP/wihT0yqUSc9YlXc87SgbQm6JNf3PWescKEmIlIzK6Uw+J+iL91XRePL5xnVhSPPxpJ0evmAjKJJ8LqiRd3uSvGAJ54BDXa+gogmebpRg/M82on1fyHziN6VYHxO/joroh45rkqERw5LebOiuz0rM2gKWr56HM67Dzj9cOM6uZHE5Ej3W/TkkS2d5xyLV8m+Ou64WcAXxrwBic3zy+4L4zqkqs6qLyijPeLrF+bGdBogddtH9SMjg0wG+mqADUkzLqQBX1kWB8uBevzYyS8DtYzhNqInTyP3678sNg+gET9G0= manuel.bovo@mbkp.i.zroot.org"
        automatic_reboot = true
      }
    }
  }
}