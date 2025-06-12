pipeline {
    agent any

    stages {
        stage('Run ansible pipeline') {
            steps {
                build job: 'ansible'
            }
        }

        stage('Test connection to deploy env') {
            steps {
                sh '''
                ansible -i ~/workspace/ansible/hosts.yaml -m ping devops-vm-3
            '''
            }
        }

        stage('Get ready for ansible run') {
            steps {
                sh '''
                cd $WORKSPACE
                echo 'Make sure .env exists (or create from .env.template if needed)'
                make env-init
                echo 'Generate .vault_pass.txt from .env'
                make vault-pass
                '''
            }
        }

        stage('Install all the components in a docker environment') {
            steps {
                ansiblePlaybook(
                    vaultCredentialsId: 'AnsibleVault',
                    playbook: 'system-pipeline-docker-compose/devops-2025/ansible-playground/playbook/docker_run.yaml',
                    inventory: 'system-pipeline-docker-compose/devops-2025/ansible-playground/hosts.yaml',
                )
            }
        }
    }
}
                // export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                // ansible-playbook -i ~/workspace/ansible/hosts.yaml \
                // ~/workspace/ansible/playbook/docker_run.yaml \
                // --vault-password-file .vault_pass.txt