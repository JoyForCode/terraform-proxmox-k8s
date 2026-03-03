data "vault_kv_secret_v2" "k8s_base" {
  mount = "terraform"
  name  = var.vault_k8s_base_path
}

data "vault_kv_secret_v2" "proxmox" {
  mount = "terraform"
  name  = var.vault_proxmox_path
}

data "vault_kv_secret_v2" "nodes" {
  for_each = toset(var.k8s_node_names)
  mount = "terraform"
  name = "${var.vault_k8s_nodes_path}/${each.key}"
}

locals {
  nodes = {
    for name in var.k8s_node_names : name => {
      vm_id = tonumber(data.vault_kv_secret_v2.nodes[name].data["vm_id"])
      ip_address = data.vault_kv_secret_v2.nodes[name].data["ip_address"]
      cores = tonumber(data.vault_kv_secret_v2.nodes[name].data["cores"])
      memory_fixed = tonumber(data.vault_kv_secret_v2.nodes[name].data["memory_fixed"])
      memory_floating = tonumber(data.vault_kv_secret_v2.nodes[name].data["memory_floating"])
      main_disk_size = tonumber(data.vault_kv_secret_v2.nodes[name].data["main_disk_size"])
      data_disk_size = tonumber(data.vault_kv_secret_v2.nodes[name].data["data_disk_size"])
      username = data.vault_kv_secret_v2.nodes[name].data["username"]
      password = data.vault_kv_secret_v2.nodes[name].data["password"]
      ssh_public_key = data.vault_kv_secret_v2.nodes[name].data["ssh_public_key"]
      gateway = data.vault_kv_secret_v2.nodes[name].data["gateway"]
      dns = data.vault_kv_secret_v2.nodes[name].data["dns"]
    }
  }
}
