pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/suneel00/sample-info.git'
        DOCKER_IMAGE = 'suneel00/sample-info:${BUILD_NUMBER}'
        DOCKER_CREDENTIALS_ID = 'dockerhub-c'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git credentialsId: 'github-c', branch: 'main', url: "${env.GITHUB_REPO}"
            }
        }
        stage('build'){
            steps{
                sh 'mvn clean install -DskipTests'
            }
        }
        stage('Test'){
            steps{
                sh 'mvn test'
                
            }
        }
        

        stage('build and Push image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

    }

}