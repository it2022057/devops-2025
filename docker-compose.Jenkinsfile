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
                sshagent(credentials: ['github-ssh']) {
                    sh '''
                        export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                        ansible-playbook -i ~/workspace/ansible/hosts.yaml ~/workspace/ansible/playbook/docker_run.yaml
                    '''
                }
            }
        }
    }
}
