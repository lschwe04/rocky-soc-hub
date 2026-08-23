provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "soc_hub" {
  name         = var.server_name
  image        = "rocky-9"
  server_type  = var.server_type
  location     = "fsn1"
  ssh_keys     = [var.ssh_key_name]
  firewall_ids = [hcloud_firewall.soc_hub_fw.id] # NEU: Firewall zugewiesen

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  labels = {
    environment = "production"
    role        = "observability-hub"
  }
}

# 1. Dynamisches Generieren der Ansible-Inventar-Datei mit der IP der neuen VM
resource "local_file" "ansible_inventory" {
  content  = <<-EOT
    [backup_servers]
    ${hcloud_server.backup_server.ipv4_address} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
  EOT
  filename = "${path.module}/../../ansible/inventories/production/hosts.ini"
}

# 2. Automatisches Ausführen des Ansible-Playbooks direkt nach dem Erstellen der VM
resource "null_resource" "run_ansible_hardening" {
  # Löst den Ansible-Lauf aus, sobald die VM und das Inventar bereit sind
  depends_on = [
    hcloud_server.backup_server,
    local_file.ansible_inventory
  ]

  # Optional: Triggert den Run neu, wenn sich die IP ändert
  triggers = {
    server_ip = hcloud_server.backup_server.ipv4_address
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/../../ansible/inventories/production/hosts.ini ${path.module}/../../ansible/playbooks/site.yml"
  }
}
