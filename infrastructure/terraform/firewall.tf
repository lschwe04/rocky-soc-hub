resource "hcloud_firewall" "soc_hub_fw" {
  name = "soc-hub-firewall"
  
  # Prometheus Scrape nur vom SOC-Hub erlauben
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "9100"
    source_ips = [
      "<SOC_HUB_IP>/32"
    ]
  }

  # Loki Log-Push nur von den spezifischen Servern zum SOC-Hub
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "3100"
    source_ips = [
      "<PRIMAEH_SERVER_IP>/32",
      "<BACKUP_SERVER_IP>/32"
    ]
  }
}
