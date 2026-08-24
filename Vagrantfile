# Vagrantfile im Hauptverzeichnis
Vagrant.configure("2") do |config|
  # Offizielles Rocky Linux 9 Image
  config.vm.box = "rockylinux/9"
  config.vm.hostname = "soc-hub-local"
  
  # Festes Host-Only-Netzwerk (Sicher abgeschottet von deinem Heimnetzwerk)
  config.vm.network "private_network", ip: "192.168.56.10"

  # VM Ressourcen (Skalierbarkeit für Logs/Metriken)
  config.vm.provider "virtualbox" do |vb|
    vb.name = "rocky-soc-hub"
    vb.memory = "4096" # 4 GB RAM (wichtig für Loki/Prometheus)
    vb.cpus = 2
  end

  # Ansible Provisionierung direkt in Vagrant integrieren
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/site.yml"
    ansible.inventory_path = "ansible/inventories/hosts.local.ini" # Korrigiert: "inventories" im Pfad
    ansible.ask_vault_pass = true # Falls du vault.yml noch nutzt
  end
end
