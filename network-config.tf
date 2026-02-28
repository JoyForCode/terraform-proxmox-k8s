resource "proxmox_virtual_environment_file" "network_data" {
  content_type = "snippets"
  datastore_id = "cloud-init-snippets"
  node_name    = "proxmox"

  source_raw {
    file_name = "network-config"
    data      = <<EOF
version: 2
ethernets:
  ens18:
    addresses: [${data.vault_kv_secret_v2.k8s_base.data["ipv4_address"]}/24]
    gateway4: ${data.vault_kv_secret_v2.k8s_base.data["gateway"]}
    nameservers:
      addresses: [${data.vault_kv_secret_v2.k8s_base.data["dns"]}]
EOF
  }
}