#!/bin/bash

cd Infrastructure
terraform init
terraform apply -auto-approve

sleep 10

cd ../Ansible

ansible-playbook ./Playbooks/generate_dynamic_inventory.yml
ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/configure_load_balancer.yml
ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/setup_all_nodes.yml
ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/create_kubernetes_cluster.yml
ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/configure_data_machine.yml
ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/configure_nginx_ingress_controller.yaml


#ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/tmp.yml
