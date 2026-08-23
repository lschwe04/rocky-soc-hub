provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "soc_hub" {
  name         = var.server_name
  image        = "rocky-9"
  server_type  = var.server_type
  location     = "fsn1"
  ssh_keys     = [var.ssh_key_name]
  firewall_ids = [hcloud_firewall.soc_hub_fw.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  labels = {
    environment = "production"
    role        = "observability-hub"
  }
}

# Dynamisches Generieren der Ansible-Inventar-Datei mit der IP des SOC-Hubs
resource "local_file" "ansible_inventory" {
  content  = <<-EOT
    [soc_hub]
    ${hcloud_server.soc_hub.ipv4_address} ansible_user=root
  EOT
  filename = "${path.module}/../../ansible/inventories/production/hosts.ini"
}
