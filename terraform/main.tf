module "vm_test" {
  source = "./modules/proxmox_vm"

  proxmox_debug      = true
  proxmox_log_enable = true
  proxmox_api_url    = "https://cube.i.zroot.org:8006/api2/json"

  vm = {
    "test" = {
      target_node = "cube"
      template    = "kubetemplate"
      network = {
        bridge = "vmbr1"
        model  = "virtio"
        # this macaddress is in the form ff:ff:ff:ff:ff:XX
        # where XX is the latest octect of a ipv4 address
        # This mapping is made automagically by an external DHCP server
        # so ff:ff:ff:ff:ff:fe  will map to 10.20.20.254 in my case
        macaddress = "FF:FF:FF:FF:FF:60"
      }
    }
  }
}