.PHONY: tf-init tf-apply ansible-deploy

tf-init:
	cd infrastructure/terraform && terraform init

tf-apply:
	cd infrastructure/terraform && terraform apply

ansible-deploy:
	ansible-playbook -i ansible/inventories/production/hosts.ini ansible/site.yml

deploy: tf-init tf-apply ansible-deploy
	@echo "SOC Hub erfolgreich deployed!"
