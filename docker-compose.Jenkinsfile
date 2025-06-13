pipeline {
    agent any

    stages {
        stage('Run ansible pipeline') {
            steps {
                build job: 'ansible'
            }
        }

        stage('Update the submodules') {
            steps {
                sh '''
                echo 'Update the submodules'
                git submodule init
                git submodule update
                '''
            }
        }

        stage('Test connection to deploy env') {
            steps {
                sh '''
                ansible -i ~/workspace/ansible/hosts.yaml -m ping devops-vm-3
            '''
            }
        }

        stage('Install all the components in a docker environment') {
            steps {
                ansiblePlaybook(
                    vaultCredentialsId: 'AnsibleVault',   // Replace with your vault credentials ID
                    playbook: 'ansible-playground/playbook/docker_run.yaml',
                    inventory: 'ansible-playground/hosts.yaml'
                )
            }
        }
    }
}
