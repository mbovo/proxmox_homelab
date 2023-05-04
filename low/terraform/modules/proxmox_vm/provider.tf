provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_tls_insecure = var.proxmox_tls_insecure
  #uses PM_API_TOKEN_ID and PM_API_TOKEN_SECRET env vars
  pm_log_enable = var.proxmox_log_enable
  pm_log_file   = var.proxmox_log_file
  pm_debug      = var.proxmox_debug
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

terraform {

  # Minimum version of terraform required for this module
  required_version = ">= 1.0"

  #experiments = [module_variable_optional_attrs]

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.6"
    }
  }
}
