variable "vm" {
  type = map(object({

    desc        = optional(string)
    onboot      = optional(bool)
    agent       = optional(bool)
    target_node = string
    boot        = optional(string)
    pxe         = optional(bool)
    template    = optional(string)
    full_clone  = optional(bool)
    iso         = optional(string)
    cores       = optional(number)
    sockets     = optional(number)
    memory      = optional(number)
    pool        = optional(string)
    init = optional(object({
      os_type      = optional(string)
      user         = optional(string)
      password     = optional(string)
      searchdomain = optional(string)
      nameserver   = optional(string)
      ipconfig0    = optional(string)
      ipconfig1    = optional(string)
      ipconfig2    = optional(string)
      ipconfig3    = optional(string)
      ipconfig4    = optional(string)
      ipconfig5    = optional(string)
    }))

    network = list(object({
      model      = string
      bridge     = string
      firewall   = optional(bool)
      link_down  = optional(bool)
      macaddress = optional(string)
      tag        = optional(number)
      rate       = optional(number)
      queues     = optional(number)
    }))

    disk = optional(list(object({
      type      = string
      storage   = string
      size      = string
      format    = optional(string)
      cache     = optional(string)
      backup    = optional(number)
      iothread  = optional(number)
      replicate = optional(number)
      ssd       = optional(number)
      mbps      = optional(number)
      media     = optional(string)
    })))
  }))
}

variable "proxmox_api_url" {
  type        = string
  description = "ProxMox VE api url"
}

variable "proxmox_tls_insecure" {
  type    = bool
  default = true
}

variable "proxmox_log_enable" {
  type    = bool
  default = false
}

variable "proxmox_log_file" {
  type    = string
  default = "terraform-plugin-proxmox.log"
}
variable "proxmox_debug" {
  type    = bool
  default = false
}