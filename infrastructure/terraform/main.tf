terraform {
  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }
  }

  # FIX: S3 Backend Integration mit State Locking via DynamoDB und Verschlüsselung
  backend "s3" {
    bucket         = "soc-terraform-state-prod"
    key            = "hub/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_firewall" "soc_hub_fw" {
  name = "soc-hub-firewall"

  # FIX: SSH Management-Zugriff streng auf Bastion/Corporate-IP limitiert (0.0.0.0/0 entfernt)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.corporate_bastion_ip]
  }

  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "51820"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3000"
    source_ips = [var.wireguard_subnet]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9100"
    source_ips = ["${var.backup_lab_ip}/32"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3100"
    source_ips = ["${var.backup_lab_ip}/32"]
  }
}

resource "hcloud_server" "soc_hub_server" {
  name         = var.server_name
  image        = "rocky-9"
  server_type  = var.server_type
  location     = "fsn1" 
  ssh_keys     = [var.ssh_key_name]
  firewall_ids = [hcloud_firewall.soc_hub_fw.id]

  labels = {
    environment = "production"
    role        = "soc-hub"
  }
}

output "soc_hub_ip" {
  value       = hcloud_server.soc_hub_server.ipv4_address
  description = "Public IPv4 address of the Rocky SOC Hub Server"
}
