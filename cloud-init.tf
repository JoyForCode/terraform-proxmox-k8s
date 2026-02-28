resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox"

  source_raw {
    data = <<-EOF
#cloud-config
hostname: k8s-node-1
timezone: Asia/Kolkata

network:
  version: 2
  ethernets:
    eno1:
      addresses:
        - ${data.vault_kv_secret_v2.k8s_base.data["ipv4_address"]}/24
      gateway4: ${data.vault_kv_secret_v2.k8s_base.data["gateway"]}
      nameservers:
        addresses:
          - ${data.vault_kv_secret_v2.k8s_base.data["dns"]}

users:
  - name: ${data.vault_kv_secret_v2.k8s_base.data["username"]}
    password: ${data.vault_kv_secret_v2.k8s_base.data["password"]}
    groups: [sudo]
    shell: /bin/bash
    ssh_authorized_keys:
      - ${data.vault_kv_secret_v2.k8s_base.data["ssh_public_key"]}

package_update: true
packages:
  - qemu-guest-agent
  - net-tools
  - ssh

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
EOF

    file_name = "user_data_cloud_config.yaml"
  }
}