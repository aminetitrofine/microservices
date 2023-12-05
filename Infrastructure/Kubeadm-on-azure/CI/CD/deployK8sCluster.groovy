pipeline {
    agent any
    
    environment {
        //TF_VAR_subscription_id = <Your Subscription_id>
        //TF_VAR_client_id = <Your Client Id>
        //TF_VAR_client_secret = <Your Client Secret>
        //TF_VAR_tenant_id = <Your Azure Intra (Active Directory) Id>
        //TF_VAR_num_masters = <Number Of masters>
        //TF_VAR_num_workers = <Number Of workers>
        
    }
    
    stages {
        stage('checkout code from GitHub') {
            steps {
                git branch: 'main', credentialsId: 'git_credentials', url: 'https://github.com/aminetitrofine/microservices.git'
            }

        }

        stage('configure access to ssh key'){
            steps {
                sh 'chmod 400 ./.ssh/id_rsa'
            }
        }

        stage('Provision Infrastructure') {
            steps {
                dir('./Infrastructure') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                    sh 'sleep 10'
                }
            }
        }
        stage('generate Dynamic inventory') {
            steps {
                dir('./Ansible') {
                    sh 'ansible-playbook ./Playbooks/generate_dynamic_inventory.yml'
                }
                
            }
        }
        stage('setup all nodes') {
            steps {
                dir('./Ansible') {
                    sh 'ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/setup_all_nodes.yml'
                }
                
            }
        }
        stage('Configure Load Balancer') {
            steps {
                dir('./Ansible') {
                    sh 'ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/configure_load_balancer.yml'
                }
                
            }
        }
        stage('Create Kubernetes Cluster') {
            steps {
                dir('./Ansible') {
                    sh 'ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/create_kubernetes_cluster.yml'
                }
                
            }
        }
        stage('Configure Ingress Controller') {
            steps {
                dir('./Ansible') {
                    sh 'ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/configure_nginx_ingress_controller.yaml'
                }
                
            }
        }
        stage('Setup data VM') {
            steps {
                dir('./Ansible') {
                    sh 'ansible-playbook -i ./Inventory/hosts.ini ./Playbooks/configure_data_machine.yml'
                }
                
            }
        }
        
    }
}