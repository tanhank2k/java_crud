pipeline {
    agent {node { label 'java-slave' }}
    environment {
        APP_NAME = 'java_hello_world'
        DOCKER_IMAGE = ''  // Update to your Docker Hub username
        GIT_COMMIT_ID = '' // Placeholder for commit ID, will be set dynamically
        DOCKER_CREDENTIALS_ID = 'eddabcf8-673d-4395-a9d1-14077f64aa08' // Replace with your Jenkins credential ID
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    // Retrieve the short commit ID
                    GIT_COMMIT_ID = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    // Define the Docker image with the commit ID suffix
                    DOCKER_IMAGE = "tanhank2k1/${APP_NAME}:${GIT_COMMIT_ID}"
                }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                     // Authenticate with Docker using credentials
                     withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                         // Login to Docker
                         sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"

                         // Build the Docker image with the commit ID tag
                         sh "docker build -t ${DOCKER_IMAGE} ."

                         // Push the Docker image to the repository
                         sh "docker push ${DOCKER_IMAGE}"

                         // Logout of Docker
                         sh "docker logout"
                     }
                }
            }
        }
    }
    post {
        success {
            echo 'Build and Docker image push were successful!'
        }
        failure {
            echo 'Build failed, please check the console output.'
        }
    }
}
