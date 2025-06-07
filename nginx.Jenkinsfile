pipeline {
    agent any

    environment {
        DOCKER_TOKEN=credentials('github-token')
        DOCKER_USER = 'it2022057'
        DOCKER_SERVER='ghcr.io'
        DOCKER_PREFIX='ghcr.io/it2022057/nginx'
    }

    stages {
        stage('Docker pull and push') {
            steps {
                sh '''
                HEAD_COMMIT=$(git rev-parse --short HEAD)
                TAG=$HEAD_COMMIT-$BUILD_ID
                docker pull nginx:alpine
                docker tag nginx:alpine $DOCKER_PREFIX:$TAG
                docker tag nginx:alpine $DOCKER_PREFIX:latest

            '''

                sh '''
                echo $DOCKER_TOKEN | docker login $DOCKER_SERVER -u $DOCKER_USER --password-stdin
                docker push $DOCKER_PREFIX --all-tags
            '''
            }
        }

        stage('Pull and run nginx') {
            steps {
                sh '''
                    docker pull $DOCKER_PREFIX:latest
                    echo "Running nginx container..."
                    docker run -d --name test-nginx -p 8081:80 $DOCKER_PREFIX:latest
                '''
            }
        }

        stage('Test nginx') {
            steps {
                sh '''
                sleep 3
                echo "Testing nginx..."
                curl --fail http://localhost:8081 || (echo "❌ NGINX failed to respond" && exit 1)
                nc -z localhost 8081 || (echo "❌ Port 8080 not open" && exit 1)
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    echo "Cleaning up the mariadb container now..."
                    docker stop test-nginx || true
                    docker rm -f test-nginx || true
                    ! lsof -i :8081 && echo "✅ Port 8081 is free" || (echo "❌ Port 8081 still in use" && exit 1)
            '''
            }
        }
    }

    post {
        always {
            mail(
                to: 'byronlouki21@gmail.com',
                from: 'byronlouki21@gmail.com',
                body: "Project ${env.JOB_NAME} <br>, Build status ${currentBuild.currentResult} <br> Build Number: ${env.BUILD_NUMBER} <br> Build URL: ${env.BUILD_URL}", subject: "JENKINS: Project name -> ${env.JOB_NAME}, Build -> ${currentBuild.currentResult}",
                mimeType: 'text/html'
            )
        }
    }
}
