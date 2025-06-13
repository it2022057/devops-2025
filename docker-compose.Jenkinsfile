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

        // stage('Get ready for ansible run') {
        //     steps {
        //         sh '''
        //         cd $WORKSPACE
        //         echo 'Make sure .env exists (or create from .env.template if needed)'
        //         make env-init
        //         echo 'Generate .vault_pass.txt from .env'
        //         make vault-pass
        //         '''
        //     }
        // }

        // stage('Copy Ansible Artifacts') {
        //     steps {
        //         copyArtifacts(
        //             projectName: 'ansible',
        //             filter: '**/*',
        //             target: 'ansible', // this will copy into ./ansible in current job
        //             flatten: false
        //         )
        //     }
        // }

        stage('Install all the components in a docker environment') {
            steps {
                ansiblePlaybook(
                    vaultCredentialsId: 'AnsibleVault',
                    playbook: 'ansible-playground/playbook/docker_run.yaml',
                    inventory: 'ansible-playground/hosts.yaml'
                )
            }
        }
    }
}
                // export ANSIBLE_CONFIG=~/workspace/ansible/ansible.cfg
                // ansible-playbook -i ~/workspace/ansible/hosts.yaml \
                // ~/workspace/ansible/playbook/docker_run.yaml \
                // --vault-password-file .vault_pass.txt