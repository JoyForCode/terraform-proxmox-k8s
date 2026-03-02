provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.vault_role_id
      secret_id = var.vault_secret_id
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.1.10:8006/api2/json"
  insecure  = true
  api_token = ephemeral.vault_kv_secret_v2.proxmox.data["api_token"]

  ssh {
    agent       = false
    username    = ephemeral.vault_kv_secret_v2.proxmox.data["user"]
    private_key = ephemeral.vault_kv_secret_v2.proxmox.data["ssh_private_key"]
  }
}
