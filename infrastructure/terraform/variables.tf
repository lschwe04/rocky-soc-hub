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

# FIX: Explizite IP-Einschränkung für SSH-Zugriffe via Bastion/Corporate-VPN
variable "corporate_bastion_ip" {
  type        = string
  description = "Öffentliche CIDR-Adresse der Bastion/Corporate-VPN für SSH-Zugriffe (z.B. 198.51.100.5/32)"
}

variable "backup_lab_ip" {
  type        = string
  default     = "203.0.113.50"
  description = "IP-Adresse des Backup-Labs für Prometheus-Scraping und Loki-Push"
}

variable "wireguard_subnet" {
  type        = string
  default     = "10.100.0.0/24"
  description = "WireGuard VPN Subnet für sicheren Dashboard-Zugriff"
}
