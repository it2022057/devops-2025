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

        stage('Install all the components in a docker environment') {
            steps {
                ansiblePlaybook(
                    vaultCredentialsId: 'AnsibleVault',
                    playbook: 'playbook/docker_run.yaml',
                    inventory: '~/workspace/ansible/playbook/docker_run.yaml',
                    // extras: '--vault-password-file .vault_pass.txt',
                    ansibleConfig: '~/workspace/ansible/ansible.cfg'
                )
                // sh '''
                //     export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                //     ansible-playbook -i ~/workspace/ansible/hosts.yaml \
                //     ~/workspace/ansible/playbook/docker_run.yaml \
                //     --vault-password-file .vault_pass.txt
                // '''
            }
        }
    }
}
