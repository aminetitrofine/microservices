# Creating K8s Cluster in Azure with Kubeadm, Terraform, and Ansible

This README file provides documentation on creating and managing a Kubernetes cluster using Kubeadm, Terraform, and Ansible. The process involves three modules: General, Compute, and Network. Additionally, there is an inventory file and two playbooks: one for creating the Kubernetes cluster and another for destroying it.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Terraform](#terraform)
    - [Terraform Commands](#terraform-commands)
    - [General Module](#general-module)
    - [Compute Module](#compute-module)
    - [Network Module](#network-module)
    - [Data Module](#data-module)
- [Ansible](#ansible)
    - [Inventory File](#inventory-file)
    - [Playbooks](#playbooks)
        - [Create Kubernetes Cluster](#create_kubernetes_cluster)
        - [Destroy Kubernetes Cluster](#destroy_kubernetes_cluster)
- [Usage](#usage)

## Prerequisites

Before proceeding with cluster creation, ensure you meet the following prerequisites:

1. Install `Azure CLI` to prepare the infrastructure environment for Terraform provisioning.
2. Install `Terraform` on the machine where you will run the cluster creation process.
3. Install `Ansible` on the machine where you will execute the playbooks (Ansible works only for Linux distributions) and ensure that the SSH flow is open.

## Terraform Commands

This command initializes the Terraform project:
```shell
terraform init
```
This command generates the Terraform execution plan:
```shell
Terraform plan 
```

This command validates the Terraform syntax:
```shell
Terraform validate 
```
This command formats the Terraform code:
```shell
Terraform fmt
```
This command creates the infrastructure:
```shell
Terraform apply -auto-approve
```
This command destroys the Azure infrastructure:
```shell
Terraform destroy -auto-approve 
```
Destroy a specific module:
```shell
terraform destroy -target=module.general.azurerm_resource_group.resourcegroup -auto-approve
```


## Module General

The General module contains the general configuration and setup required for the Kubernetes cluster. It includes the following files:

- `main.tf` : Defines the Resource Group.
- `variables.tf` :  Defines the input variables used in the module.
- `outputs.tf` : Defines the output variables exposed by the module.

Ensure to update the necessary variables in `variables.tf` to match your desired configuration.

## Module Compute

The Compute module focuses on provisioning the virtual machines (VMs) required for the Kubernetes cluster. It includes the following files:

- `main.tf` : Defines the resources needed for computation.
- `variables.tf` : Defines the input variables used in the module.
- `outputs.tf` : Defines the output variables exposed by the module.

Update the variables in variables.tf to match your desired configuration for compute instances, such as VM sizes, quantity, and image.

## Module Network

The Network module manages the network configuration for the Kubernetes cluster. It includes the following files:

- `main.tf` : Defines the resources needed for the network.
- `variables.tf` : Defines the input variables used in the module.
- `outputs.tf` : Defines the output variables exposed by the module.

Update the variables in `variables.tf` to match your desired network configuration, such as VPC, subnets, and security groups.


## Data Module

The Data module creates the virtual network with the dedicated data machine to install an NFS server:

- `main.tf`: Defines the resources needed for the network.
- `variables.tf`: Defines the input variables used in the module.
- `outputs.tf`: Defines the output variables exposed by the module.

Update the variables in `variables.tf` to match your desired network configuration, such as VPC, subnets, and security groups.

## Inventory File

The inventory file is used by Ansible to manage the Kubernetes cluster. It lists the IP addresses or hostnames of the Kubernetes master and worker nodes. Ensure to update the inventory file (`inventory.ini`) with the appropriate information before running the playbooks.

**Example `hosts.ini`:**

```ini
[workers]
worker-1 ansible_host=192.168.1.11
worker-2 ansible_host=192.168.1.12


## Playbooks

To execute a playbook, navigate to the Ansible directory and run the following command:
This command will execute the playbook named playbook_name.yml, using the inventory file located at ./Inventory/hosts.ini.
```shell
ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/playbook_name.yml
```



The deployK8s.sh script deploys the K8s cluster using Terraform and Ansible commands. It is executed using the following command:
```shell
    ./deployK8s.sh
```

## Usage

To use the project, clone it using the following command:
```shell
    git clone https://github.com/aminetitrofine/microservices.git
```

Then, navigate to the Infrastructure directory and create the terraform.tfvars file using the following command:
```shell
    cd microservices/Infrastructure/Kubeadm-on-azure
    touch terraform.tfvars
```
Add the Azure connection information to the terraform.tfvars file:
```shell
    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```
Also, specify the desired number of Kubernetes nodes, for example:
```shell
    num_workers = 2
    num_masters = 1
```
Alternatively, set them as environment variables:
```shell
    export TF_VAR_subscription_id="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    export TF_VAR_client_id="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    export TF_VAR_client_secret="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    export TF_VAR_tenant_id="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```
