variable "hcloud_token" {
  type        = string
  sensitive   = true
  description = "Hetzner Cloud API Token"
}

variable "server_name" {
  type        = string
  default     = "rocky-soc-hub"
  description = "Hostname des Monitoring-Servers"
}

variable "server_type" {
  type        = string
  default     = "cax11"
  description = "Instanz-Größe"
}

variable "ssh_key_name" {
  type        = string
  description = "Name des hinterlegten SSH-Keys in Hetzner"
}

# --- NEU: Für WireGuard- & Backup-Lab-Anbindung ---
variable "backup_lab_ip" {
  type        = string
  default     = "203.0.113.50"
  description = "IP-Adresse des Backup-Labs für Prometheus-Scraping und Loki-Push"
}

variable "wireguard_subnet" {
  type        = string
  default     = "10.10.0.0/24" # Passe dies an dein echtes WireGuard-Netz an
  description = "WireGuard VPN Subnet für sicheren Dashboard-Zugriff"
}
