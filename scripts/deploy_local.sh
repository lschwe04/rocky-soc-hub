#!/bin/bash
set -e

echo "🚀 Starte lokales SOC-Hub Deployment mit VirtualBox & Vagrant..."

# 1. Startet die VM in VirtualBox und lädt Rocky Linux 9 herunter
# 2. Führt automatisch das Ansible Playbook aus (siehe Vagrantfile)
vagrant up --provision

echo "✅ Deployment abgeschlossen!"
echo "📊 Grafana ist erreichbar unter: http://192.168.56.10:3000"
echo "🔐 (Standard-Login wird durch deine Ansible-Rolle/Vault definiert)"
