# PROXMOX HomeLab

This repo contains the definition `as code` to recreate configuration of my Proxmox home lab.
The installation/configuration of proxmox itself is out-of-scope and is not included in this repo.

## Architecture

The lab is actually composed of 3 nodes, each one with the following specs:

- CPU: 12 x Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz (1 socket)
- RAM: 48GB
- Storage: 1 x 512GB NVMe + 1 x 1TB SDD
- Network: 1 x 1Gbps + 1 x 10Gbps
- OS: Proxmox VE 7.4

VLAN is used to separate traffic between VMs and the rest of the networks

Current configuration is:

- p1 (spare) Currently powered off to save energy _and money_
- p2 (test) Activated on demand to test new features (wake on-lan from github self-hosted runner)
- p3 (prod) Always on, hosting all the services

### Infrastructure Levels

I decided to split the infrastructure into 2 different levels:

- **low-level**: contains all the resources that are needed to run the cluster itself (VMs, networks, storage, etc)
- **high-level**: contains all the resources that are needed to run the services (apps, databases, etc)

#### Low-level

Low level infrastructure in this repo is managed by [terraform](https://www.terraform.io) [packer](https://www.packer.io) and [ansible](https://www.ansible.com).

In this directory you will find all the code needed to:

- create the templates for the VMs
- create the required VMs
- configure the VMs with ansible (eg: kubernetes cluster with kubeadm and the like)

The terraform state is stored on terraform cloud free plan.

#### High-level

High level infrastructure in this repo is managed by [flux](https://fluxcd.io) and sometimes [helm](https://helm.sh) some others [kustomize](https://kustomize.io).

In this directory you will find all the code needed to:

- deploy the "infrastructure" apps needed by the cluster (eg: metallb, ingress controller, etc)
- deploy the "services" apps

You will find a `envs` subdirectory referencing each kubernetes cluster

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

## CI/CD

The CI/CD pipeline is based on **Github Actions** running on self-hosted runners.
Opening a PR will trigger a pipeline that:

- use WoL to power on the test node and wait until it's up and running
- if changes are detected on the `packer` folder, it will rebuild the VM template on test node
- if changes are detected on the `terraform` folder, it will run a `terraform apply` to test the changes on test node
- if changes are detected on the `ansible` folder, it will run a `ansible-lint` and molecule tests
- if everything is ok, it will enable the ability to merge the PR

Merging the PR will trigger a pipeline that:

- if changed are detected on the `packer` folder, it will rebuild the VM template on prod node
- if changes are detected on the `terraform` folder, it will run a `terraform apply` to apply the changes on prod node

The `high-level` directory contains everything synced by [flux](https://fluxcd.io) on the prod node. Merging changes on `main` branch will be automatically applied on the relative clusters.

## TODO

- Implement all the test
