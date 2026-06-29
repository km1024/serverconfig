locals {
  # Common Configuration
  target_node  = "pve1"
  template_id  = 9000
  gateway      = "10.0.0.1"
  storage_pool = "zpool" 
  
  admin_user   = "ops"
  admin_keys   = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINShrwRGM/GTb7F5yvHLS9bIN0Il56ouG2Yz2+3P/ErL karthik@Karthiks-MacBook-Air.local",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNBpzg7EeX8NMk59rKN+qRb8kTqP5bb41xyh9ysaMrl karthik@manticore" 
  ]

  # Machine-Specific Configuration
  vms = {
    srv1 = {
      hostname = "srv1"
      ip       = "10.1.30.1/8"
      data_gb  = 20
    }
  }
}

resource "proxmox_virtual_environment_vm" "servers" {
  for_each = local.vms

  name      = each.value.hostname
  node_name = local.target_node

  clone {
    vm_id = local.template_id
    full  = true
  }

  disk {
    datastore_id = local.storage_pool
    interface    = "scsi1"
    size         = each.value.data_gb
    file_format  = "raw"
  }

  agent {
    enabled = true
  }

  initialization {
    datastore_id = local.storage_pool
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = local.gateway
      }
    }
    user_account {
      username = local.admin_user
      keys     = local.admin_keys
    }
  }
}

