variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://pve1.home.1p64.net:8006/" 
  api_token = var.proxmox_api_token
  insecure  = true
}

