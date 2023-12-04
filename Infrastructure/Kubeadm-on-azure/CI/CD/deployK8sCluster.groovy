pipeline {
    agent any
    
    environment {
        TF_VAR_subscription_id = "7ab49b35-ad5d-4963-b328-25a5b04ce665"
        TF_VAR_client_id = "ae708d97-1507-4ef4-865a-afcd7a584d5d"
        TF_VAR_client_secret = "LjM8Q~xbCJ7IUUKLvIBt2xBWqAw~djX4LOgISc6M"
        TF_VAR_tenant_id = "edcb425c-438f-4ba1-bbe9-67eed05d87a7"
        TF_VAR_num_masters = 1
        TF_VAR_num_workers = 1
        
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