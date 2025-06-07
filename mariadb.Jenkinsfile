pipeline {
    agent any

    environment {
        DOCKER_TOKEN=credentials('github-token')
        DOCKER_USER='it2022057'
        DOCKER_SERVER='ghcr.io'
        DOCKER_PREFIX='ghcr.io/it2022057/mariadb'
    }

    stages {
        stage('Docker pull and push') {
            steps {
                sh '''
                HEAD_COMMIT=$(git rev-parse --short HEAD)
                TAG=$HEAD_COMMIT-$BUILD_ID
                docker pull mariadb:10.2.44
                docker tag mariadb:10.2.44 $DOCKER_PREFIX:$TAG
                docker tag mariadb:10.2.44 $DOCKER_PREFIX:latest

            '''

                sh '''
                echo $DOCKER_TOKEN | docker login $DOCKER_SERVER -u $DOCKER_USER --password-stdin
                docker push $DOCKER_PREFIX --all-tags
            '''
            }
        }

        stage('Pull and Run Mailhog') {
            steps {
                sh '''
                docker pull $DOCKER_PREFIX:latest
                echo "Running mariadb container..."
                docker run -d \
                    --name test-mariadb -p 3306:3306 \
                    -e MYSQL_DATABASE=mariadb \
                    -e MYSQL_USER=myuser \
                    -e MYSQL_PASSWORD=pass12345 \
                    $DOCKER_PREFIX:latest
            '''
            }
        }

        stage('Test mariadb') {
            steps {
                sh '''
                sleep 3
                echo "Testing mariadb connection..."
                mysql -h localhost -P 3306 -u myuser -ppass12345 -e "SHOW DATABASES;" \
                    && echo "✅ Database is reachable" \
                    || echo "❌ Could not connect to the database"
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    echo "Cleaning up the mariadb container now..."
                    docker stop test-mariadb || true
                    docker rm -f test-mariadb || true
                    ! lsof -i :3306 && echo "✅ Port 3306 is free" || (echo "❌ Port 3306 still in use" && exit 1)

            '''
            }
        }
    }

    post {
        always {
            mail(
                to: 'byronlouki21@gmail.com',
                from: 'byronlouki21@gmail.com',
                body: "Project ${env.JOB_NAME} <br> Build status ${currentBuild.currentResult} <br> Build Number: ${env.BUILD_NUMBER} <br> Build URL: ${env.BUILD_URL}", subject: "JENKINS: Project name -> ${env.JOB_NAME}, Build -> ${currentBuild.currentResult}",
                mimeType: 'text/html'
            )
        }
    }
}
