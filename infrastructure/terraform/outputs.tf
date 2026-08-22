output "soc_hub_ip" {
  value       = hcloud_server.soc_hub.ipv4_address
  description = "Öffentliche IP-Adresse des SOC-Hubs"
}
