data "vault_kv_secret_v2" "k8s_base" {
  mount = "terraform"
  name = var.vault_k8s_base_path
}

data "vault_kv_secret_v2" "proxmox" {
  mount = "terraform"
  name = var.vault_proxmox_path
}
