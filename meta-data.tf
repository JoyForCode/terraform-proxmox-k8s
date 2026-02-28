resource "proxmox_virtual_environment_file" "meta_data" {
  content_type = "snippets"
  datastore_id = "cloud-init-snippets"
  node_name    = "proxmox"

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: k8s-node-1
    EOF

    file_name = "meta-data-cloud-config.yaml"
  }
}