#!/bin/bash
set -e

echo "1. Starte Terraform Rollout..."
cd infrastructure/terraform
terraform apply -auto-approve

# IP automatisch aus Terraform Output auslesen
BACKUP_IP=$(terraform output -raw backup_server_ip)

echo "2. Schreibe Ansible Inventar mit IP: $BACKUP_IP"
cd ../../ansible
echo "[backup_servers]" > inventories/production/hosts.ini
echo "$BACKUP_IP ansible_user=root" >> inventories/production/hosts.ini

echo "3. Starte Ansible Hardening..."
ansible-playbook -i inventories/production/hosts.ini playbooks/site.yml
echo "Komplettes Setup erfolgreich abgeschlossen!"
