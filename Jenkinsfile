pipeline {
    agent any 
    tools {
        gradle 'Gradle 7.5.1'  // Specify the version of Gradle to use
    }
    environment {
        IMAGE = "gradle_unzip"
        FILE_NAME = "gradle.zip"  // Corrected the filename from 'grandle.zip' to 'gradle.zip'
        DIR_UNZIP = "demo" 
        DOCKER_IMAGE = "${IMAGE}:${BUILD_NUMBER}"
        DOCKER_CONTAINER = "springbootG_jenkins"
        DOCKER_CREDENTIALS_ID = "dockertoken"
    }

    stages {
        stage("Check Versions") {
            steps {
                script {
                    echo "Gradle version:"
                    sh 'gradle --version'  // Display the Gradle version
                    echo "Java version:"
                    sh 'java --version'  // Display the Java version
                }
            }
        }

        stage('Unzip File') {
            steps {
                script {
                    echo "Checking if the file ${FILE_NAME} exists and unzipping it if present..."
                    sh """
                        if [ -f '${FILE_NAME}' ]; then
                            echo "Removing existing directory ${DIR_UNZIP}..."
                            rm -rf ${DIR_UNZIP}  
                            echo "Unzipping the file..."
                            unzip -o '${FILE_NAME}' -d ${DIR_UNZIP}/  
                        else
                            echo "'${FILE_NAME}' does not exist."
                            exit 1 
                        fi
                    """
                }
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    echo "Building the Gradle project..."
                    dir("${DIR_UNZIP}") {  // Use the correct variable name
                        sh "docker build -t ${DOCKER_IMAGE} ."  
                    }
                    sh "docker images | grep -i ${IMAGE}" 
                }
            }
        }
    }
}
