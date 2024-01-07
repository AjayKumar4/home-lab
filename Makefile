SHELL :=/bin/bash

ANSIBLE := $(shell command -v ansible-playbook 2>/dev/null || echo "ansible-playbook package is missing")
ANSIBLE_GALAXY := $(shell command -v ansible-galaxy 2>/dev/null || echo "ansible-galaxy package is missing")

.PHONY: prerequisite microk8s tailscale restart upgrade k3s k3s-networking vault minio
.DEFAULT_GOAL := all

tailscale: 
	$(ANSIBLE) ./tailscale/main.yml -i ./hosts.ini
	
vault:
	$(ANSIBLE) ./vault/main.yml -i ./hosts.ini

minio:
	$(ANSIBLE) ./minio/main.yml -i ./hosts.ini

microk8s: 
	$(ANSIBLE) ./tailscale/main.yml -i ./inventory/home-lab/hosts.ini

k3s:
	$(ANSIBLE) ./k3s/main.yml -i ./k3s/hosts.ini

k3s-networking: 
	$(ANSIBLE) ./k3s/networking.yml -i ./k3s/hosts.ini

k3s-reset: 
	$(ANSIBLE) ./k3s/reset.yml -i ./k3s/hosts.ini

restart:
	$(ANSIBLE) ./misc/reboot.yml -i ./inventory/home-lab/hosts.ini

upgrade:
	$(ANSIBLE) ./misc/upgrade.yml -i ./inventory/home-lab/hosts.ini

