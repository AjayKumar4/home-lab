SHELL :=/bin/bash

ANSIBLE := $(shell command -v ansible-playbook 2>/dev/null || echo "ansible-playbook package is missing")
ANSIBLE_GALAXY := $(shell command -v ansible-galaxy 2>/dev/null || echo "ansible-galaxy package is missing")

.PHONY: k3s-delete k3s-prerequisite k3s-setup k3s-post restart upgrade
.DEFAULT_GOAL := all

k3s-prerequisite: 
	$(ANSIBLE_GALAXY) collection install -r ./k3s/collections/requirements.yml

k3s-setup: k3s-prerequisite
	$(ANSIBLE) ./k3s/site.yml -i ./inventory/home-lab/hosts.ini

k3s-post: k3s-setup
	$(ANSIBLE) ./k3s/site.yml -i ./inventory/home-lab/hosts.ini

k3s-delete: k3s-prerequisite
	$(ANSIBLE) ./k3s/reset.yml -i ./inventory/home-lab/hosts.ini

restart:
	$(ANSIBLE) ./misc/reboot.yml -i ./inventory/home-lab/hosts.ini

upgrade:
	$(ANSIBLE) ./misc/upgrade.yml -i ./inventory/home-lab/hosts.ini

k3s: k3s-prerequisite k3s-setup k3s-post