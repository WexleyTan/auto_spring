pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        IMAGE = "neathtan/spring_adv"
        DOCKER_IMAGE = "${IMAGE}:${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = "dockertoken"
        GIT_MANIFEST_REPO = "https://github.com/WexleyTan/auto_spring_manifest.git"
        GIT_BRANCH = "master"
        MANIFEST_REPO = "auto_spring_manifest"
        MANIFEST_FILE_PATH = "deployment.yaml"
        GIT_CREDENTIALS_ID = 'git_pass'
    }
    stages {
        stage("Checkout") {
            steps {
                echo "Running on $NODE_NAME"
                echo "Build Number: ${BUILD_NUMBER}"
                sh 'docker image prune --all -f'
            }
        }

         stage("clean package") {
            steps {
              echo "Building the application..."
              sh ' mvn clean install '
            }
        }

        stage("build and push docker image") {
            steps {
                script {
                    echo "Building docker image..."
                    sh ' docker build -t ${DOCKER_IMAGE} .'
                    sh ' docker images | grep -i ${IMAGE} '
                    
                    echo "Log in Docker hub using Jenkins credentials..."
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                      sh 'echo "${DOCKER_PASS} ${DOCKER_USER}" '
                      sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }
                    echo "Pushing the image to Docker hub"
                    sh 'docker push ${DOCKER_IMAGE}'
                    
                }
            }
        }


        stage("Cloning the Manifest File") {
            steps {
                script {
                    echo "Checking if the manifest repository exists and removing it if necessary..."
                    sh """
                        if [ -d "${env.MANIFEST_REPO}" ]; then
                            echo "Directory ${env.MANIFEST_REPO} exists, removing it..."
                            rm -rf ${env.MANIFEST_REPO}
                        fi
                    """
                    
                    echo "Cloning the manifest repository..."
                    sh "git clone -b ${env.GIT_BRANCH} ${env.GIT_MANIFEST_REPO} ${env.MANIFEST_REPO}"
                }
            }
        }
    }
}
