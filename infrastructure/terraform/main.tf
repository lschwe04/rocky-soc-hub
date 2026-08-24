terraform {
  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# --- 1. CLOUD FIREWALL (ZERO-TRUST SICHERHEIT) ---
resource "hcloud_firewall" "soc_hub_fw" {
  name = "soc-hub-firewall"

  # SSH Management Zugriff
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

# --- NEU: WireGuard VPN Port für die Nodes ---
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "51820"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # Grafana UI: NUR über das WireGuard VPN Subnetz erlaubt!
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3000"
    source_ips = [
      var.wireguard_subnet
    ]
  }

  # Prometheus Node Exporter: Nur vom Backup-Lab abrufbar
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9100"
    source_ips = [
      "${var.backup_lab_ip}/32"
    ]
  }

  # Loki Log-Push: Nur vom Backup-Lab erlaubt
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3100"
    source_ips = [
      "${var.backup_lab_ip}/32"
    ]
  }
}

# --- 2. HETZNER CLOUD SERVER (SOC-HUB) ---
resource "hcloud_server" "soc_hub_server" {
  name         = var.server_name
  image        = "rocky-9"
  server_type  = var.server_type
  location     = "fsn1" # Ersetzt das veraltete 'datacenter'-Attribut durch die Region Falkenstein
  ssh_keys     = [var.ssh_key_name]
  firewall_ids = [hcloud_firewall.soc_hub_fw.id]

  labels = {
    environment = "production"
    role        = "soc-hub"
  }
}

# --- 3. OUTPUTS ---
output "soc_hub_ip" {
  value       = hcloud_server.soc_hub_server.ipv4_address
  description = "Public IPv4 address of the Rocky SOC Hub Server"
}
