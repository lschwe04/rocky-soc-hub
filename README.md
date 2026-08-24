# Rocky SOC Hub

Automatisierte Bereitstellung eines zentralen Security Operations Center (SOC) Überwachungs-Hubs auf Hetzner Cloud mit Rocky Linux 9, Prometheus, Loki, Alertmanager und Grafana.

## Voraussetzungen

- **Terraform** >= 1.5.0
- **Ansible** >= 2.15.0
- **Hetzner Cloud Account** & API Token
- OpenSSH-Client

## Erforderliche Umgebungsvariablen

Setze vor dem Deployment die folgenden Umgebungsvariablen in deiner Shell:

```bash
export HCLOUD_TOKEN="dein_hetzner_api_token"
export SOC_HOST_IP="deine_lokale_oder_vpn_ip"
