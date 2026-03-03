resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  for_each = local.nodes

  content_type = "snippets"
  datastore_id = "cloud-init-snippets"
  node_name    = "proxmox"

  source_raw {
    data = <<-EOF
#cloud-config
hostname: ${each.key}
timezone: Asia/Kolkata

users:
  - default
  - name: ${each.value.username}
    passwd: ${each.value.password}
    lock_passwd: false
    groups: [sudo]
    shell: /bin/bash
    ssh_authorized_keys:
      - ${each.value.ssh_public_key}

packages:
  - qemu-guest-agent
  - net-tools
  - git

ansible: 
  install_method: distro
  pull:
    - url: "https://github.com/JoyForCode/k8s-ansible-playbooks.git"
    playbook_names: [install_kubeadm.yml]

disk_setup:
  /dev/sdb:
    table_type: gpt
    layout: true
    overwrite: true

fs_setup:
  - device: /dev/sdb1
    filesystem: ext4
    overwrite: true
    label: containerd

mounts:
  - [ LABEL=containerd, /var/lib/containerd, ext4, "defaults,nofail,noatime,discard", "0", "2" ]

package_update: true
  
runcmd:
  - [ systemctl, enable, --now, qemu-guest-agent ]
EOF

    file_name = "user_data_${each.key}.yaml"
  }
}
