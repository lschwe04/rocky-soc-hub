output "soc_hub_ip" {
  value       = hcloud_server.soc_hub.ipv4_address
  description = "Public IPv4 address of the central SOC Hub"
}
