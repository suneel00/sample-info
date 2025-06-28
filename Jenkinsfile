pipeline {
    agent {
        docker {
            image 'abhishekf5/maven-abhishek-docker-agent:v1'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    // environment {
    //     DOCKER_IMAGE = 'suneel00/sample-info'
    //     IMAGE_TAG = "${BUILD_NUMBER}"
    //     FULL_IMAGE = "${DOCKER_IMAGE}:${IMAGE_TAG}"
    //     DOCKER_CREDENTIALS_ID = 'dockerhub-c'
    // }
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-c', branch: 'main', url: 'https://github.com/suneel00/sample-info.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Static Code Analysis') {
            environment {
                SONAR_URL = 'http://<ec2-ip>:9000'
            }
            steps {
                withCredentials([string(credentialsId: 'SonarQube', variable: 'sonarqube-token')]) {
                    sh 'cd mvn sonar:sonar -Dsonar.login=$sonarqube-token -Dsonar.host.url=${SonarQube}'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${dockerhub-c}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' deployment.yaml
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                """
            }
        }
    }
}
