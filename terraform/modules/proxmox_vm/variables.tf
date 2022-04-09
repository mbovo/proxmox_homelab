variable "vm" {
  type = map(object({
    target_node = string
    template    = string
    full_clone  = optional(bool)
    cores       = optional(number)
    sockets     = optional(number)
    memory      = optional(number)
    network = object({
      bridge     = string
      firewall   = optional(bool)
      link_down  = optional(bool)
      model      = string
      macaddress = optional(string)
    })
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