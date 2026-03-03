resource "proxmox_virtual_environment_file" "network_config" {
  for_each = local.nodes

  content_type = "snippets"
  datastore_id = "cloud-init-snippets"
  node_name    = "proxmox"

  source_raw {
    data = <<-EOF
version: 2
ethernets:
  id0:
    match:
      driver: virtio_net
    addresses: 
      - ${each.value.ip_address}
    gateway4: ${each.value.gateway}
    nameservers:
      addresses: 
        - ${each.value.dns}
EOF

    file_name = "network_config_${each.key}.yaml"
  }
}