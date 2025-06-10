pipeline {
    agent any

    parameters {
        booleanParam(name: 'INSTALL_MARIADB', defaultValue: true, description: 'Install MariaDB database')
        booleanParam(name: 'INSTALL_MINIO', defaultValue: true, description: 'Install Minio object storage')
        booleanParam(name: 'INSTALL_MAILHOG', defaultValue: true, description: 'Install Mailhog email test service')
        booleanParam(name: 'INSTALL_SPRING', defaultValue: true, description: 'Install Spring Boot app')
    }

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

        stage('Setup jenkins server') {
            steps {
                sh '''
                ansible -i ~/workspace/ansible/hosts.yaml ~/workspace/ansible/playbook/setup_jenkins.yaml
            '''
            }
        }

        stage('Install mariadb') {
            when {
                expression { return params.INSTALL_MARIADB }
            }
            steps {
                sh '''
                    export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                    ansible-playbook -i ~/workspace/ansible/hosts.yaml -l db-server ~/workspace/ansible/playbook/mariaDB.yaml
                '''
            }
        }

        stage('Install minio') {
            when {
                expression { return params.INSTALL_MINIO }
            }
            steps {
                sh '''
                    export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                    ansible-playbook -i ~/workspace/ansible/hosts.yaml -l devops-vm-2 ~/workspace/ansible/playbook/minIO.yaml
                '''
            }
        }

        stage('Install mailhog') {
            when {
                expression { return params.INSTALL_MAILHOG }
            }
            steps {
                sh '''
                    export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                    ansible-playbook -i ~/workspace/ansible/hosts.yaml -l devops-vm-2 ~/workspace/ansible/playbook/mailhog.yaml
                '''
            }
        }

        stage('Install main app') {
            when {
                expression { return params.INSTALL_SPRING }
            }
            steps {
                //sshagent(credentials: ['jenkins-ssh']) {
                    sh '''
                        ssh-add -l
                        export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                        ansible-playbook -i ~/workspace/ansible/hosts.yaml -l devops-vm-2 ~/workspace/ansible/playbook/spring.yaml
                    '''
                // }
            }
        }
    }
}
