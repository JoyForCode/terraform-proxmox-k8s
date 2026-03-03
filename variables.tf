variable "vault_address" {
  type        = string
  description = "Vault server URL"
}

variable "vault_role_id" {
  type        = string
  description = "Vault approle role_id"
}

variable "vault_secret_id" {
  type        = string
  sensitive   = true
  description = "Vault approle secret_id"
}

variable "vault_k8s_base_path" {
  type    = string
  default = "k8s-base"
}

variable "vault_k8s_nodes_path" {
  type = string
  description = "Vault base path for k8s node configs"
  default = "k8s-nodes"
}

variable "k8s_node_names" {
  type = list(string)
  description = "List of k8s node names matching Vault secret paths"
  default = ["k8s-control-plane", "k8s-worker-1", "k8s-worker-2"]
}

variable "vault_proxmox_path" {
  type    = string
  default = "proxmox"
}
