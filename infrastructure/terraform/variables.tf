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
  default     = "cax11" # ARM-basiert oder cx22 (x86)
  description = "Instanz-Größe"
}

variable "ssh_key_name" {
  type        = string
  description = "Name des hinterlegten SSH-Keys in Hetzner"
}
