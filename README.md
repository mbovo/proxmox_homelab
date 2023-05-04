# PROXMOX HomeLab

This repo contains the definition `as code` to recreate configuration of my Proxmox home lab.
The installation/configuration of proxmox itself is out-of-scope and is not included in this repo.

## Requirements

- [Taskfile](https://taskfile.dev)
- [Hashicorp Packer](https://www.packer.io)
- [Hashicorp Terraform](https://www.terraform.io)
- [Ansible](https://www.ansible.com)
- [pre-commit](https://pre-commit.com)
- [ProxMox VE](https://www.proxmox.com/en/proxmox-ve)

### Rebuild VMs templates

```bash
cd packer
packer init

export USER_SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
packer build -var username='proxmox_username' -var token='proxmox_api_token' -var sshkey=${USER_SSH_KEY} .
```

### Create virtual machines

```bash
cd terraform

terraform init

export PM_API_TOKEN_ID="username@pve!token_name"
export PM_API_TOKEN_SECRET="a-valid-token-secret"

terraform plan
terraform apply

```
