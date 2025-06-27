pipeline {
    agent {
    docker {
        image 'maven:3.8.7-eclipse-temurin-17'
        args '-u root --network host -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    environment {
        DOCKER_IMAGE = 'suneel00/sample-info'
        IMAGE_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE = "${DOCKER_IMAGE}:${IMAGE_TAG}"
        DOCKER_CREDENTIALS_ID = 'dockerhub-c'
    }
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-c', branch: 'main', url: 'https://github.com/suneel00/sample-info.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -B clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker build -t ${FULL_IMAGE} .
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${FULL_IMAGE}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    sed -i 's|image: .*|image: ${FULL_IMAGE}|' deployment.yaml
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                """
            }
        }
    }
}
