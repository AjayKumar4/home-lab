SHELL :=/bin/bash

export PROJECT := portfolio
export VERSION := 2.0.0
export IMAGE_NAME := $(DOCKER_USERNAME)/$(PROJECT)
ANSIBLE := $(shell command -v ansible-playbook 2>/dev/null || echo "ansible-playbook package is missing")
ANSIBLE_GALAXY := $(shell command -v ansible-galaxy 2>/dev/null || echo "ansible-galaxy package is missing")

.PHONY: k3s-delete k3s-prerequisite k3s-setup restart upgrade
.DEFAULT_GOAL := release

k3s-prerequisite: 
	$(ANSIBLE_GALAXY) collection install -r ./k3s/collections/requirements.yml

k3s-setup: 
	k3s-prerequisite
	$(ANSIBLE) ./k3s/site.yml -i ./inventory/home-lab/hosts.ini

k3s-delete:
	k3s-prerequisite
	$(ANSIBLE) ./k3s/reset.yml -i ./inventory/home-lab/hosts.ini

restart:
	$(ANSIBLE) ./misc/reboot.yml -i ./inventory/home-lab/hosts.ini

upgrade:
	$(ANSIBLE) ./misc/upgrade.yml -i ./inventory/home-lab/hosts.ini

release: clean login build push