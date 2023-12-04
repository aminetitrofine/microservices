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

        stage('Destroy Infrastructure') {
            steps {
                dir('./../../infrastructure_deployment/workspace/Infrastructure') {
                    //sh 'terraform destroy -target=module.general.azurerm_resource_group.resource_group -auto-approve'
                }
            }
        }

    }
    
}