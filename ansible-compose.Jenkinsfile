pipeline {
    agent any

    stages {
        stage('Run ansible pipeline') {
            steps {
                build job: 'ansible'
            }
        }

        stage('Check Forwarding') {
            steps {
                sshagent(credentials: ['jenkins-ssh']) {
                    sh '''
                    echo "🔐 Jenkins sees SSH key:"
                    ssh-add -l

                    echo "🔁 Testing SSH agent forwarding and cloning in remote VM:"
                    ssh ansible-vm '
                        echo "🔑 Remote sees SSH key:" &&
                        ssh-add -l &&
                        #echo "📥 Cloning repository from GitHub..." &&
                        #rm -rf test-clone &&
                        #git clone git@github.com:it2022057/ansible-playground.git test-clone &&
                        echo "✅ Git clone succeeded" || echo "❌ Git clone failed"  && 
                        cd test-clone &&
                        ansible-playbook playbook/spring.yaml -l devops-vm-2
                    '
                '''
                }
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
                        export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                        ansible-playbook -i ~/workspace/ansible/hosts.yaml -l db-server,devops-vm-2 ~/workspace/ansible/playbook/setup_all.yaml
                    '''
                }
            }
        }
    }
}
