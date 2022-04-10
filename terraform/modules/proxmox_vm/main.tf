
resource "proxmox_vm_qemu" "proxmox_vm" {
  for_each = var.vm
  name     = each.key
  desc     = defaults(each.value.desc, null)
  onboot   = defaults(each.value.onboot, true)

  agent       = defaults(each.value.agent, false)
  target_node = defaults(each.value.target_node, null)
  boot        = defaults(each.value.boot, "cdn")

  # PXE, clone and iso are mutually exclusive
  pxe = defaults(each.value.pxe, false)

  clone      = defaults(each.value.template, null)
  full_clone = defaults(each.value.full_clone, true)

  iso = defaults(each.value.iso, null)

  cores   = defaults(each.value.cores, 1)
  sockets = defaults(each.value.sockets, 1)
  memory  = defaults(each.value.memory, 512)

  pool         = defaults(each.value.pool, null)
  force_create = defaults(each.value.force_create, false)

  os_type      = defaults(each.value.init.os_type, null)
  ciuser       = defaults(each.value.init.user, null)
  cipassword   = defaults(each.value.init.password, null)
  searchdomain = defaults(each.value.init.searchdomain, null)
  nameserver   = defaults(each.value.init.nameserver, null)
  ipconfig0    = defaults(each.value.init.ipconfig0, null)
  ipconfig1    = defaults(each.value.init.ipconfig1, null)
  ipconfig2    = defaults(each.value.init.ipconfig2, null)
  ipconfig3    = defaults(each.value.init.ipconfig3, null)
  ipconfig4    = defaults(each.value.init.ipconfig4, null)
  ipconfig5    = defaults(each.value.init.ipconfig5, null)

  automatic_reboot = defaults(each.value.init.automatic_reboot, false)

  dynamic "network" {
    for_each = each.value.network

    content {
      model     = network.value.model
      bridge    = network.value.bridge
      firewall  = defaults(network.value.firewall, false)
      link_down = defaults(network.value.link_down, false)
      macaddr   = defaults(network.value.macaddress, null)
      tag       = defaults(network.value.tag, -1)
      rate      = defaults(network.value.rate, 0)
      queues    = defaults(network.value.queues, 1)
    }
  }

  dynamic "disk" {
    for_each = each.value.disk
    content {
      type      = disk.value.type
      storage   = disk.value.storage
      size      = disk.value.size
      format    = defaults(disk.value.format, "raw")
      cache     = defaults(disk.value.cache, "none")
      backup    = defaults(disk.value.backup, 0)
      iothread  = defaults(disk.value.iothread, 0)
      replicate = defaults(disk.value.replicate, 0)
      ssd       = defaults(disk.value.ssd, 0)
      mbps      = defaults(disk.value.mbps, 0)
      media     = defaults(disk.value.media, "disk")
    }
  }

}