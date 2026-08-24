output "soc_hub_ipv4" {
  description = "Öffentliche IPv4-Adresse des SOC-Hub-Servers"
  value       = hcloud_server.soc_hub_server.ipv4_address
}

output "soc_hub_id" {
  description = "ID der erstelleten Hetzner Cloud Instanz"
  value       = hcloud_server.soc_hub_server.id
}
