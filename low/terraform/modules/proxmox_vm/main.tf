
resource "proxmox_vm_qemu" "proxmox_vm" {
  for_each = var.vm
  name     = each.key
  desc     = each.value.desc
  vmid     = try(each.value.vmid, 0)
  onboot   = try(each.value.onboot, true)

  agent       = try(each.value.agent, 0)
  target_node = each.value.target_node
  boot        = try(each.value.boot, "cdn")

  # PXE, clone and iso are mutually exclusive
  pxe = try(each.value.pxe, false)

  clone      = each.value.template
  full_clone = try(each.value.full_clone, true)

  iso = each.value.iso

  cores   = try(each.value.cores, 1)
  sockets = try(each.value.sockets, 1)
  memory  = try(each.value.memory, 512)

  pool         = each.value.pool
  force_create = try(each.value.force_create, false)

  os_type      = each.value.init.os_type
  ciuser       = each.value.init.user
  cipassword   = each.value.init.password
  searchdomain = each.value.init.searchdomain
  nameserver   = each.value.init.nameserver
  ipconfig0    = each.value.init.ipconfig0
  ipconfig1    = each.value.init.ipconfig1
  ipconfig2    = each.value.init.ipconfig2
  ipconfig3    = each.value.init.ipconfig3
  ipconfig4    = each.value.init.ipconfig4
  ipconfig5    = each.value.init.ipconfig5

  sshkeys          = each.value.init.sshkeys
  automatic_reboot = try(each.value.init.automatic_reboot, false)

  dynamic "network" {
    for_each = each.value.network

    content {
      model     = network.value.model
      bridge    = network.value.bridge
      firewall  = try(network.value.firewall, false)
      link_down = try(network.value.link_down, false)
      macaddr   = network.value.macaddress
      tag       = try(network.value.tag, -1)
      rate      = try(network.value.rate, 0)
      queues    = try(network.value.queues, 1)
    }
  }

  dynamic "disk" {
    for_each = each.value.disk
    content {
      type      = disk.value.type
      storage   = disk.value.storage
      size      = disk.value.size
      format    = try(disk.value.format, "raw")
      cache     = try(disk.value.cache, "none")
      backup    = try(disk.value.backup, 0)
      iothread  = try(disk.value.iothread, 0)
      replicate = try(disk.value.replicate, 0)
      ssd       = try(disk.value.ssd, 0)
      mbps      = try(disk.value.mbps, 0)
      media     = try(disk.value.media, "disk")
    }
  }

}