packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_api_token_id" {
  type    = string
  default = "root@pam!packer"
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

source "proxmox-iso" "ubuntu" {
  proxmox_url              = "https://10.1.50.1:8006/api2/json"
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  node                 = "pve1"
  vm_id                = 9000
  template_name        = "ubuntu-2404-golden"
  template_description = "Ubuntu 24.04.4 LTS (Built ${timestamp()})"

  cores   = 2
  memory  = 2048

  boot_iso {
    type     = "ide"
    iso_file = "local:iso/ubuntu-24.04.4-live-server-amd64.iso"
    unmount  = true
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disks {
    disk_size    = "20G"
    format       = "raw"
    storage_pool = "zpool"
    type         = "virtio"
  }

  os = "l26"

  http_directory = "http"
  boot_wait      = "5s"
  boot_command = [
    "c",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
    "<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]

  ssh_username = "ops"
  ssh_private_key_file = "~/.ssh/id_ed25519"
  ssh_timeout  = "20m"
}

build {
  sources = ["source.proxmox-iso.ubuntu"]
}

