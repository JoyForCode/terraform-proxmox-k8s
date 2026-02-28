resource "proxmox_virtual_environment_file" "meta_data" {
  content_type = "snippets"
  datastore_id = "cloud-init-snippets"
  node_name    = "proxmox"

  source_raw {
    file_name = "meta-data"
    data      = "instance-id: k8s-base-node-1\nlocal-hostname: k8s-base-node-1"
  }
}