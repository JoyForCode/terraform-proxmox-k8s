resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "cloud-init-snippets"
  node_name    = "proxmox"

  source_raw {
    data = <<-EOF
#cloud-config
hostname: k8s-node-1
timezone: Asia/Kolkata

users:
  - default
  - name: ${data.vault_kv_secret_v2.k8s_base.data["username"]}
    passwd: ${data.vault_kv_secret_v2.k8s_base.data["password"]}
    lock_passwd: false
    groups: [sudo]
    shell: /bin/bash
    ssh_authorized_keys:
      - ${data.vault_kv_secret_v2.k8s_base.data["ssh_public_key"]}

disk_setup:
  /dev/sdb:
    table_type: gpt
    layout: true
    overwrite: true

fs_setup:
  - device: /dev/sdb1
    filesystem: ext4
    overwrite: true
    label: data

mounts:
  - [ /dev/sdb1, /data, auto, "defaults", "0", "0" ]

package_update: true
packages:
  - qemu-guest-agent
  - net-tools
  
runcmd:
  - [ systemctl, enable, --now, qemu-guest-agent ]
EOF

    file_name = "user_data_cloud_config.yaml"
  }
}
