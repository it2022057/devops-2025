pipeline {
    agent any

    environment {
        DOCKER_TOKEN=credentials('github-token')
        DOCKER_USER='it2022057'
        DOCKER_SERVER='ghcr.io'
        DOCKER_PREFIX='ghcr.io/it2022057/minio'
    }

    stages {
        stage('Docker pull and push') {
            steps {
                sh '''
                HEAD_COMMIT=$(git rev-parse --short HEAD)
                TAG=$HEAD_COMMIT-$BUILD_ID
                docker pull minio/minio:latest
                docker tag minio/minio:latest $DOCKER_PREFIX:$TAG
                docker tag minio/minio:latest $DOCKER_PREFIX:latest

            '''

                sh '''
                echo $DOCKER_TOKEN | docker login $DOCKER_SERVER -u $DOCKER_USER --password-stdin
                docker push $DOCKER_PREFIX --all-tags
            '''
            }
        }

        stage('Pull and Run Minio') {
            steps {
                sh '''
                docker pull $DOCKER_PREFIX:latest
                echo "Running minio container..."
                docker run -d \
                    --name test-minio \
                    -p 9000:9000 -p 9001:9001\
                    -e MINIO_ROOT_USER=minioadmin \
                    -e MINIO_ROOT_PASSWORD=minioadmin \
                    $DOCKER_PREFIX:latest server /data --console-address ":9001"
            '''
            }
        }

        stage('Test minio') {
            steps {
                sh '''
                sleep 3
                echo "Testing if minio's ports are open and ready..."
                nc -z localhost 9000 || (echo "❌ MinIO S3 port failed" && exit 1)
                nc -z localhost 9001 || (echo "❌ MinIO Console port failed" && exit 1)
                echo "✅ MinIO is responsive"
            '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    echo "Cleaning up the minio container now..."
                    docker stop test-minio || true
                    docker rm -f test-minio || true
            '''
            }
        }
    }

    post {
        always {
            mail  to: "byronlouki21@gmail.com", from: "byronlouki21@gmail.com", body: "Project ${env.JOB_NAME} <br>, Build status ${currentBuild.currentResult} <br> Build Number: ${env.BUILD_NUMBER} <br> Build URL: ${env.BUILD_URL}", subject: "JENKINS: Project name -> ${env.JOB_NAME}, Build -> ${currentBuild.currentResult}"
        }
    }
}
