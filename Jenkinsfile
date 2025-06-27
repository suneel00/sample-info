pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'suneel00/sample-info'
        IMAGE_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE = "${DOCKER_IMAGE}:${IMAGE_TAG}"
        DOCKER_CREDENTIALS_ID = 'dockerhub-c'
        SONARQUBE_ENV = 'SonarQube'
    }
    tools {
        maven 'maven3.8.7'
        jdk 'jdk17'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-c', url: 'https://github.com/suneel00/sample-info.git'
            }
        }
        stage('Code Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
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
