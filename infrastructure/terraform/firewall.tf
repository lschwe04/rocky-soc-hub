variable "backup_lab_ip" {
  type        = string
  default     = "203.0.113.50" # Ersetze dies mit der echten IP deines Backup-Labs
  description = "IP-Adresse des Backup-Labs für Prometheus-Scraping und Loki-Push"
}

resource "hcloud_firewall" "soc_hub_fw" {
  name = "soc-hub-firewall"
  
  # Grafana UI Zugriff (Dashboard im Browser)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3000"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Prometheus Node Exporter Abruf (Vom Backup-Lab zum SOC-Hub / oder umgekehrt je nach Topologie)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9100"
    source_ips = [
      "${var.backup_lab_ip}/32"
    ]
  }

  # Loki Log-Push (Erlaubt dem Backup-Lab, Logs AN den SOC-Hub zu senden)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3100"
    source_ips = [
      "${var.backup_lab_ip}/32"
    ]
  }
}
