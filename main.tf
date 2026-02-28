terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.97.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "5.7.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = "k8s-base-node-1"
  description = "Will be used for deployment of K8 cluster"
  tags        = ["terraform", "K8s", "ubuntu_server"]

  node_name = "proxmox"
  vm_id     = 5001

  stop_on_destroy = true

  bios = "ovmf"

  scsi_hardware = "virtio-scsi-single"
  boot_order    = ["scsi0"]

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
    floating  = 2048
  }

  serial_device {

  }

  vga {
    type = "serial0"
  }

  machine = "q35"

  disk {
    datastore_id = "local-lvm"
    file_id      = "local:iso/noble-server-cloudimg-amd64.img"
    interface    = "scsi0"
	discard = "on"
	iothread = true
  }

  efi_disk {
    datastore_id = "local-lvm"
    file_format  = "raw"
    type         = "4m"
  }

  initialization {

    #   user_account {
    # 	username = data.vault_kv_secret_v2.k8s_base.data["username"] 
    # 	password = data.vault_kv_secret_v2.k8s_base.data["password"]
    # 	keys = [data.vault_kv_secret_v2.k8s_base.data["ssh_public_key"]]
    #   }

    #   dns {
    #     servers = [data.vault_kv_secret_v2.k8s_base.data["dns"]]
    #   }

    #   ip_config {
    #     ipv4 {
    # 	address = data.vault_kv_secret_v2.k8s_base.data["ipv4_address"]
    # 	gateway = data.vault_kv_secret_v2.k8s_base.data["gateway"]
    #     }
    #   }
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    network_data_file_id = proxmox_virtual_environment_file.network_config.id
    #meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }
}

# resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_lts_img" {
#   content_type = "import"
#   datastore_id = "local"
#   node_name    = "proxmox"
#   url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
#   file_name    = "noble-numat-server-lts.qcow2"
# }
