#!/bin/bash
set -e

echo "1. Starte Terraform Rollout..."
cd infrastructure/terraform
terraform apply -auto-approve

# Korrekten SOC-Hub Output auslesen
SOC_HUB_IP=$(terraform output -raw soc_hub_ip)

echo "2. Schreibe Ansible Inventar mit IP: $SOC_HUB_IP"
cd ../../ansible
echo "[soc_hub]" > inventories/production/hosts.ini
echo "$SOC_HUB_IP ansible_user=root" >> inventories/production/hosts.ini

echo "3. Starte Ansible Deployment..."
ansible-playbook -i inventories/production/hosts.ini site.yml
echo "SOC-Hub Setup erfolgreich abgeschlossen!"
