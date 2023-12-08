# microservices
This repository serves as the grading assessment for the Cloud Computing lecture and includes plans for incorporating various features. Below are the steps to create and configure the infrastructure.


## Getting Started :

To use the project, clone it using the following command:
```shell
    git clone https://github.com/aminetitrofine/microservices.git
```

In the "keys" directory, add the JSON file required for Terraform calls to the GCP environment.


Next, navigate to the Infrastructure/Terraform directory and create the terraform.tfvars file using the following command:
```shell
    cd microservices/Infrastructure/Terraform
    touch terraform.tfvars
```
and configure the `project_id` variable with your actual GCP project_id

## Infrastructure Setup :
To create the infrastructure, follow these steps:


This command initializes the Terraform project:
```shell
terraform init
```
This command creates the infrastructure:
```shell
Terraform apply -auto-approve
```
## Configuring Load Testing VM
To configure the VM for load testing, follow these additional steps: 

Change the directory to the Ansible directory and generate the dynamic inventory : 
```shell
    cd cd ./../Ansible/Inventory
    python3 generate_dynamic_inventory.py
```
And then we navigate to the Playbook directory, and we run the following commands :
```shell
    cd cd ./../Playbooks
    ansible-playbook -i ./../Inventory/hosts.ini configure_test-machine.yaml
    ansible-playbook -i ./../Inventory/hosts.ini deploy_load-test.yaml
```

Note: The comprehensive report contains detailed information about the different installation processes for the application that runs on the Infrastructure.