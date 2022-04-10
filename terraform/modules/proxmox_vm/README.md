## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 2.9.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_vm_qemu.proxmox_vm](https://registry.terraform.io/providers/telmate/proxmox/2.9.6/docs/resources/vm_qemu) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_proxmox_api_url"></a> [proxmox\_api\_url](#input\_proxmox\_api\_url) | ProxMox VE api url | `string` | n/a | yes |
| <a name="input_proxmox_debug"></a> [proxmox\_debug](#input\_proxmox\_debug) | n/a | `bool` | `false` | no |
| <a name="input_proxmox_log_enable"></a> [proxmox\_log\_enable](#input\_proxmox\_log\_enable) | n/a | `bool` | `false` | no |
| <a name="input_proxmox_log_file"></a> [proxmox\_log\_file](#input\_proxmox\_log\_file) | n/a | `string` | `"terraform-plugin-proxmox.log"` | no |
| <a name="input_proxmox_tls_insecure"></a> [proxmox\_tls\_insecure](#input\_proxmox\_tls\_insecure) | n/a | `bool` | `true` | no |
| <a name="input_vm"></a> [vm](#input\_vm) | n/a | <pre>map(object({<br><br>    desc        = optional(string)<br>    onboot      = optional(bool)<br>    agent       = optional(bool)<br>    target_node = string<br>    boot        = optional(string)<br>    pxe         = optional(bool)<br>    template    = optional(string)<br>    full_clone  = optional(bool)<br>    iso         = optional(string)<br>    cores       = optional(number)<br>    sockets     = optional(number)<br>    memory      = optional(number)<br>    pool        = optional(string)<br>    init = optional(object({<br>      os_type      = optional(string)<br>      user         = optional(string)<br>      password     = optional(string)<br>      searchdomain = optional(string)<br>      nameserver   = optional(string)<br>      ipconfig0    = optional(string)<br>      ipconfig1    = optional(string)<br>      ipconfig2    = optional(string)<br>      ipconfig3    = optional(string)<br>      ipconfig4    = optional(string)<br>      ipconfig5    = optional(string)<br>    }))<br><br>    network = list(object({<br>      model      = string<br>      bridge     = string<br>      firewall   = optional(bool)<br>      link_down  = optional(bool)<br>      macaddress = optional(string)<br>      tag        = optional(number)<br>      rate       = optional(number)<br>      queues     = optional(number)<br>    }))<br><br>    disk = optional(list(object({<br>      type      = string<br>      storage   = string<br>      size      = string<br>      format    = optional(string)<br>      cache     = optional(string)<br>      backup    = optional(number)<br>      iothread  = optional(number)<br>      replicate = optional(number)<br>      ssd       = optional(number)<br>      mbps      = optional(number)<br>      media     = optional(string)<br>    })))<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
