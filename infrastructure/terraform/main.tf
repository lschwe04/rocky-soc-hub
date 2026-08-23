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
