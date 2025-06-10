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
                sshagent(credentials: ['jenkins-ssh']) {
                    sh '''
                        ssh-add -l
                        eval "$(ssh-agent -s)"
                        ssh-add -l
                        export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                        ansible-playbook -i ~/workspace/ansible/hosts.yaml ~/workspace/ansible/playbook/docker_run.yaml
                    '''
                }
            }
        }
    }
}
