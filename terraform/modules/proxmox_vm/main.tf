
resource "proxmox_vm_qemu" "proxmox_vm" {
  for_each = var.vm
  name     = each.key

  target_node = each.value.target_node
  clone       = each.value.template
  full_clone  = each.value.full_clone

  cores   = each.value.cores
  sockets = each.value.sockets
  memory  = each.value.memory

  network {
    bridge    = each.value.network.bridge
    firewall  = each.value.network.firewall
    link_down = each.value.network.link_down
    model     = each.value.network.model
    macaddr   = each.value.network.macaddress
  }

}