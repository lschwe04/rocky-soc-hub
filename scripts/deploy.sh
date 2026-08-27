#!/bin/bash
set -euo pipefail

echo "1. Starte Terraform Rollout..."
cd infrastructure/terraform
terraform init
terraform apply -auto-approve

# Korrekten SOC-Hub Output auslesen und exportieren
export SOC_HOST_IP=$(terraform output -raw soc_hub_ip)

if [ -z "$SOC_HOST_IP" ]; then
    echo "Fehler: SOC_HOST_IP konnte nicht aus Terraform extrahiert werden."
    exit 1
fi

echo "2. Starte Ansible Deployment mit dynamischem Inventar (IP: $SOC_HOST_IP)..."
cd ../../ansible

# Nutzt die Datei hosts.yml, verlangt nach dem Vault-Passwort für die Secrets
ansible-playbook -i inventories/production/hosts.yml site.yml --ask-vault-pass

echo "SOC-Hub Setup erfolgreich und sicher abgeschlossen!"
