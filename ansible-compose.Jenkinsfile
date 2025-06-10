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
                ansible -i ~/workspace/ansible/hosts.yaml -m ping devops-vm-2,db-server
            '''
            }
        }

        stage('Install system components all at once') {
            steps {
                sshagent(credentials: ['jenkins-ssh']) {
                    sh '''
                        ssh-add -l
                        eval "$(ssh-agent -s)"
                        ssh-add -l
                        export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                        ansible-playbook -i ~/workspace/ansible/hosts.yaml -l db-server,devops-vm-2 ~/workspace/ansible/playbook/setup_all.yaml
                    '''
                }
            }
        }
    }
}
