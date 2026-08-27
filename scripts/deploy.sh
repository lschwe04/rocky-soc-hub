#!/usr/bin/env bash
# Enterprise Automated SOC-Hub Deployment Orchestrator
set -euo pipefail
IFS=$'\n\t'

cleanup_on_error() {
  local exit_code=$?
  local line_no=$1
  echo -e "\n\033[0;31m[FATAL] Deployment fehlgeschlagen in Zeile ${line_no} mit Exit-Code ${exit_code}.\033[0m" >&2
  exit "${exit_code}"
}
trap 'cleanup_on_error ${LINENO}' ERR

echo -e "\033[0;34m[+] 1. Überprüfe Umgebungsvariablen und Abhängigkeiten...\033[0m"
command -v terraform >/dev/null 2>&1 || { echo "Terraform ist nicht installiert."; exit 1; }
command -v ansible-playbook >/dev/null 2>&1 || { echo "Ansible ist nicht installiert."; exit 1; }

echo -e "\033[0;34m[+] 2. Starte Terraform Infrastructure Provisioning...\033[0m"
cd infrastructure/terraform
terraform init -input=false
terraform apply -auto-approve -input=false

SOC_HOST_IP=$(terraform output -raw soc_hub_ip)
if [[ -z "${SOC_HOST_IP}" ]]; then
    echo -e "\033[0;31m[ERROR] Terraform Output 'soc_hub_ip' ist leer!\033[0m" >&2
    exit 1
fi
export SOC_HOST_IP
echo -e "\033[0;32m[SUCCESS] Target IP via Terraform: ${SOC_HOST_IP}\033[0m"

echo -e "\033[0;34m[+] 3. Starte Ansible Enterprise Deployment...\033[0m"
cd ../../ansible
ansible-playbook -i inventories/production/hosts.yml site.yml --ask-vault-pass

echo -e "\033[0;32m[SUCCESS] SOC Hub Rollout vollständig abgeschlossen!\033[0m"
