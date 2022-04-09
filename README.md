# PROXMOX HomeLab

This repo contains the definition `as code` to create basic configuration of ProxMox home lab.
Here are defined vm templates and the terraform resource to instantiate them into running VMs
The installation/configuration of proxmox itself is out-of-scope and is not included in this repo.

## Usage

Need tools

- [Taskfile](https://taskfile.dev)
- [Hashicorp Packer](https://www.packer.io)
- [Hashicorp Terraform](https://www.terraform.io)
- [ProxMox VE](https://www.proxmox.com/en/proxmox-ve)

### Rebuild VMs templates

```bash
cd packer
packer init

export USER_SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
packer build -var username='proxmod_username' -var token='proxmox_api_token' -var sshkey=${USER_SSH_KEY} .
```

### Create virtual machines

```bash
cd terraform

terraform init

export PM_API_TOKEN_ID="terraform-prov@pve!mytoken"
export PM_API_TOKEN_SECRET="afcd8f45-acc1-4d0f-bb12-a70b0777ec11"

terraform plan
terraform apply

```