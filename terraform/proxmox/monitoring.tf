resource "proxmox_virtual_environment_vm" "monitoring" {
  name      = "svp01monitoring01"
  node_name = "metal"
  vm_id     = 101

  clone {
    vm_id        = 9000
    datastore_id = "fast1"
    full         = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "fast1"
    interface    = "scsi0"
    size         = 20
    file_format  = "raw"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    datastore_id = "fast1"
  }
}
