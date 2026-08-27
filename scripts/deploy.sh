#!/bin/bash
set -e

echo "1. Starte Terraform Rollout..."
cd infrastructure/terraform
terraform init
terraform apply -auto-approve

# Korrekten SOC-Hub Output auslesen und exportieren
export SOC_HOST_IP=$(terraform output -raw soc_hub_ip)

echo "2. Starte Ansible Deployment mit dynamischem Inventar (IP: $SOC_HOST_IP)..."
cd ../../ansible

# Nutzt die Datei hosts.yml, welche SOC_HOST_IP als dynamische Umgebungsvariable ausliest
ansible-playbook -i inventories/production/hosts.yml site.yml

echo "SOC-Hub Setup erfolgreich abgeschlossen!"
