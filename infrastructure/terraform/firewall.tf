resource "hcloud_firewall" "soc_hub_fw" {
  name = "soc-hub-firewall"
  
  # Grafana UI Zugriff (Damit du das Dashboard im Browser siehst)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3000"
    source_ips = [
      "0.0.0.0/0", # Oder im Idealfall nur deine aktuelle Heim-/Büro-IP!
      "::/0"
    ]
  }

  # Loki Log-Push (Erlaubt dem Backup-Lab, Logs AN den SOC-Hub zu senden)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3100"
    source_ips = [
      "<DEINE_BACKUP_LAB_IP>/32" # WICHTIG: Hier die ECHTE IP des Backup-Servers eintragen!
    ]
  }
}
