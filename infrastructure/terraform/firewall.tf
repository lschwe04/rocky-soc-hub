resource "hcloud_firewall" "soc_hub_fw" {
  name = "soc-hub-firewall"
  
  # NEU: Grafana UI Zugriff NUR über WireGuard VPN (Sicherheitsaspekt aus Punkt 2)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3000"
    source_ips = [
      var.wireguard_subnet
    ]
  }

  # Prometheus Node Exporter Abruf vom Backup-Lab
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9100"
    source_ips = [
      "${var.backup_lab_ip}/32"
    ]
  }

  # Loki Log-Push vom Backup-Lab
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3100"
    source_ips = [
      "${var.backup_lab_ip}/32"
    ]
  }
}
