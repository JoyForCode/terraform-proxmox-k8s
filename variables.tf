variable "vault_address" {
   type = string
  description = "Vault server URL"
}

variable "vault_role_id" {
  type = string
  description = "Vault approle role_id"
}

variable "vault_secret_id" {
  type = string
  sensitive = true
  description = "Vault approle secret_id"
}

variable "vault_k8s_base_path" {
   type = string
  default = "k8s-base"
}

variable "vault_proxmox_path" {
  type = string
  default = "proxmox"
}
